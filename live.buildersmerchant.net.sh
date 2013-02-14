#!/bin/bash
rm ./.htaccess
rm ./cache
rm ./config/.htaccess
rm ./config/Application.cfm
rm ./config/CacheBox.cfc
rm ./config/MobileRules.xml.cfm
rm ./config/ModelMappings.cfm
rm ./config/Routes.cfm
rm ./config/Rules.xml.cfm
rm ./config/WireBox.cfc
rm ./favicon.ico
rm ./handlers
rm ./includes
rm ./interceptors
rm ./layouts
rm ./logs
rm ./model
rm ./modules
rm ./plugins
rm ./views
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/.htaccess
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/cache
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/.htaccess ./config/
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/Application.cfm ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/CacheBox.cfc ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/MobileRules.xml.cfm ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/ModelMappings.cfm ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/Routes.cfm ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/Rules.xml.cfm ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/config/WireBox.cfc ./config
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/favicon.ico
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/handlers
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/includes
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/interceptors
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/layouts
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/logs
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/model
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/modules
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/plugins
ln -s /fs/sites/ebiz/buildersMerchant.net/live.buildersmerchant.net/web/views
