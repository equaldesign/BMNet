<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns:v="urn:schemas-microsoft-com:vml">
    <head><meta name="robots" content="noindex,nofollow"></meta>
<meta property="og:title" content="Your Birdbox Invite Request"></meta>
</head><body style="height:100% !important;margin-top:0;margin-bottom:0;margin-right:0;margin-left:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;width:100% !important;" >
        <cfif args.tracker>
        <cfoutput><img src="http://#cgi.http_host#/marketing/email/campaign/track?cmnpn=#args.campaignID#&ct=#args.contactID#" width="1" height="1"></cfoutput>
        </cfif>
        <style type="text/css">
            p {
                margin:10px 0;
            }
        </style>
        <!--[if gte mso 9]>
        <v:background fill="t">
            <v:fill type="tile" src="http://dev.buildersmerchant.net/includes/images/email/bg.jpg" />
        </v:background>
        <![endif]-->
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td align="center" background="http://dev.buildersmerchant.net/includes/images/email/bg.jpg">
                    <table width="717" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td align="center" background="http://dev.buildersmerchant.net/includes/images/email/paper.png" width="717" height="738" valign="top">
                                <!--[if gte mso 9]>
                                <v:rect  strokecolor="none" fillcolor="none" style="width:717px;height:738px;" >
                                    <v:fill type="tile" src="http://dev.buildersmerchant.net/includes/images/email/paper.png"/></v:fill>
                                </v:rect>
                                <v:shape id="theText" style="position:absolute;width:717px;height:738px;" >
                                <![endif]-->
                                <table width="717" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="3" height="220"></td>
                                    </tr>
                                    <tr>
                                        <td width="100"></td>
                                        <td  valign="top" style="font-family:Museo, Helvetica Neue, sans-serif;font-size:14px;" >
                                            <p style="color:#8f8f8f;font-size:12px;text-transform:uppercase;margin-top:0;margin-bottom:0;margin-right:0;margin-left:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" >
                                                <cfoutput>#DateFormatOrdinal(now(),"DDDD DD MMMM YYYY")#</cfoutput>
                                            </p>
                                            <div id="mainContent">
                                            <cfoutput>#args.emailBody#</cfoutput>
                                            </div>
                                        </td>
                                        <td width="100"></td>
                                    </tr>
                                </table>
                                <!--[if gte mso 9]>
                                </v:shape>
                                <![endif]-->
                            </td>
                        </tr>
                    </table>
                    <p style="color:#8f8f8f;font-size:12px;text-transform:uppercase;margin-top:0;margin-bottom:0;margin-right:0;margin-left:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                      You are receiving this email because you are a customer of <cfoutput>#request.BMNet.siteName#</cfoutput>. You are free to <a style="color:#FFF" <cfoutput>href="http://#cgi.http_host#/marketing/email/recipient/unsubscribe?ct=#args.contactID#"</cfoutput>>unsubscribe</a> at any time.
                    </p>
                </td>
            </tr>
        </table>
    </body>
</html>