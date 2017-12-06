# EnvDevPHPBase

EnvDevPHPBase is a PHP container base designed to be used like a base for a utilisation into the [EnvDev project](https://vfac.fr/projects/envdev).
The utlisation outside this project is naturally possible.

## PHP Version

Three PHP versions are available through image's tags:

- 5.6 : `docker push vfac/envdevphpbase:5.6`
- 7.0 : `docker push vfac/envdevphpbase:7.0`
- 7.1 : `docker push vfac/envdevphpbase:7.1`
- 7.2 : `docker push vfac/envdevphpbase:7.2`

The latest version of EnvDevPHPBase (latest) (`docker push vfac/envdevphpbase`) is a image with the last version of PHP available.

## PHP Customization

To customize the PHP image you can share your `php.ini` file into `/usr/local/etc/php/php.ini` into your Dockerfile or docker-compose file.

## Complements

### Maildev configuration

The maildev configuration has been added into this image to be used into the [EnvDev project](https://vfac.fr/projects/envdev).
There are no consequence if you use this image for an another utilisation.

### X-Debug

X-Debug (2.5.5) is installed with standard options.
Two options have been customized: 
    - remote_enable=on
    - remote_autostart=off

### Composer

Composer (1.5.5) is installed to be used with your configuration of PHP.