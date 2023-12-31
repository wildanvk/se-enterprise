<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;
use CodeIgniter\Filters\CSRF;
use CodeIgniter\Filters\DebugToolbar;
use CodeIgniter\Filters\Honeypot;
use CodeIgniter\Filters\InvalidChars;
use CodeIgniter\Filters\SecureHeaders;
use App\Filters\Auth;
use App\Filters\FilterGudang;
use App\Filters\RoleFilter;

class Filters extends BaseConfig
{
    /**
     * Configures aliases for Filter classes to
     * make reading things nicer and simpler.
     */
    public array $aliases = [
        'csrf'          => CSRF::class,
        'toolbar'       => DebugToolbar::class,
        'honeypot'      => Honeypot::class,
        'invalidchars'  => InvalidChars::class,
        'secureheaders' => SecureHeaders::class,
        'auth'          => Auth::class,
        'RoleFilter' => \App\Filters\RoleFilter::class,
    ];

    /**
     * List of filter aliases that are always
     * applied before and after every request.
     */
    public array $globals = [
        // 'before' => [
        //     'auth' => ['except' => ['auth', 'auth/*', '/']],
        // ],
        // 'after' => [
        //     'auth' => ['except' => [
        //         'dashboard',
        //         'supplier', 'supplier/*',
        //         'barangmentah', 'barangmentah/*', 'barangjadi', 'barangjadi/*',
        //         'stokbarangmentah', 'stokbarangmentah/*', 'stokbarangjadi', 'stokbarangjadi/*',
        //         'barangmasukmentah', 'barangmasukmentah/*', 'barangkeluarjadi', 'barangkeluarjadi/*',
        //         'barangkeluarmentah', 'barangkeluarmentah/*', 'laporan/', 'laporan/*',

        //         'dashboard/*',
        //         'supplierapi', 'supplierapi/*',
        //         'barangmentahapi', 'barangmentahapi/*', 'barangjadiapi', 'barangjadiapi/*',
        //         'stokbarangmentahapi', 'stokbarangmentahapi/*', 'stokbarangjadiapi', 'stokbarangjadiapi/*',
        //         'barangmasukmentahapi', 'barangmasukmentahapi/*', 'barangkeluarjadiapi', 'barangkeluarjadiapi/*',
        //         'barangkeluarmentahapi', 'barangkeluarmentahapi/*', 'laporan/', 'laporan/*',

        //         'logout', 'logout/*'
        //     ]],
        // ],
    ];

    /**
     * List of filter aliases that works on a
     * particular HTTP method (GET, POST, etc.).
     *
     * Example:
     * 'post' => ['foo', 'bar']
     *
     * If you use this, you should disable auto-routing because auto-routing
     * permits any HTTP method to access a controller. Accessing the controller
     * with a method you don’t expect could bypass the filter.
     */
    public array $methods = [];

    /**
     * List of filter aliases that should run on any
     * before or after URI patterns.
     *
     * Example:
     * 'isLoggedIn' => ['before' => ['account/*', 'profiles/*']]
     */
    public array $filters = [];
}
