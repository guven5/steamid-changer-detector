#include <amxmodx>
#include <amxmisc>
#include <fvault>

#define pluginprefix "[ Knife Protection ]"

new const plugininfo[ ][ ] = {
   "Anti OstroG",
   "1.0",
   "raizo"
}

new const g_vaultname[ ] = "antisteamidchanger";

new steamidchange_logs[ 54 ];

public plugin_init() {
   register_plugin(plugininfo[ 0 ], plugininfo[ 1 ], plugininfo[ 2 ]);
   
   mkdir("addons/amxmodx/logs/steamidchanger");
   format(steamidchange_logs, charsmax(steamidchange_logs), "addons/amxmodx/logs/steamidchanger/steamidchanger.log", steamidchange_logs);
}

public client_connect(client) {
   new szdata[ 35 ];
   if(fvault_get_data(g_vaultname, user_ip(client), szdata, charsmax(szdata))) {
      loadcmd(client);
      if(!equal(user_authid(client), szdata)) {
         kickuser(client);
         return PLUGIN_HANDLED
      }
   }
   else if(!fvault_get_data(g_vaultname, user_ip(client), szdata, charsmax(szdata))) {
      savecmd(client);
      loadcmd(client);
   }
   return PLUGIN_CONTINUE
}

stock kickuser(const index) {
   new szdata[ 35 ];
   
   fvault_get_data(g_vaultname, user_ip(index), szdata, charsmax(szdata));
   
   client_print(index, print_chat, "%s Use Steam Id Changer , Disable Ct-Shield And Join After!", pluginprefix);
   server_cmd("kick #%d ^"%s Steam Id Changer Detected , Enable First Steam Id And Connect  , First Steam Id Is : %s.^"", get_user_userid(index), pluginprefix, szdata);
   log_to_file(steamidchange_logs, "Steam Id Changer Detected Player %s .", user_ip(index));
}

stock user_authid(const index) {
   new authid[ 35 ];
   get_user_authid(index, authid, charsmax(authid));
   return authid;
}

stock user_ip(const index) {
   new ip[ 35 ];
   get_user_ip(index, ip, charsmax(ip), 1);
   return ip;
}

stock savecmd(const index) {
   fvault_set_data(g_vaultname, user_ip(index), user_authid(index));
}

stock loadcmd(const index) {
   fvault_get_data(g_vaultname, user_ip(index), user_authid(index), 34);
}
