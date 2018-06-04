<?php
// check domain max
// 04062018: nawawi

( php_sapi_name() === 'cli' ) || exit;

$cmd = basename($_SERVER['argv'][0]);
if ( !isset($_SERVER['argv'][1]) || !file_exists($_SERVER['argv'][1])
    || !isset($_SERVER['argv'][2]) ) {
    echo "Usage: {$cmd} [file input] [file output]\n";
    exit(1);
}

$file_input = $_SERVER['argv'][1];
$file_output = $_SERVER['argv'][2];

function _filter_mx($list_domain) {
    $ok = 0;
    if ( is_array($list_domain) && !empty($list_domain) ) {
        foreach($list_domain as $domain) {
            if ( preg_match("/^127\.0/", $domain) 
                || $domain == '0.0.0.0' ) continue;
            $ok++;
        }
    }
    return ( $ok > 0 ? true : false );
}

function _verify($file_input, $file_output) {
    if ( ($fopen_fi = fopen($file_input, "r")) !== false ) {
        $fopen_fo = fopen($file_output, "w");

        while( ($buff = fgets($fopen_fi, 500)) !== false) {
            $buff = trim($buff);
            $fline = $buff{0};
            if ( $fline === '#' || $fline === ';' || $fline === '//' ) continue;

            if ( @getmxrr($buff, $mxinfo) ) {
                if ( !empty($mxinfo) && _filter_mx($mxinfo) ) {
                    echo "{$buff} -> ".implode(",", $mxinfo)."\n";
                    fwrite($fopen_fo, "{$buff}\n");
                }
            }
        }

        @fclose($fopen_fo);
    }
    @fclose($fopen_fi);
}

_verify($file_input, $file_output);

exit(0);
