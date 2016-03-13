<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">
<policyconfig>
    
  <action id="org.pantheon.elementary-tweaks.egtk">
    <description gettext-domain="@GETTEXT_PACKAGE@">Change elementary theme (egtk)</description>
    <message gettext-domain="@GETTEXT_PACKAGE@">Authentication is required to update elementary theme files</message>
    <icon_name>system-users</icon_name>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>auth_admin_keep</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">@PKGDATADIR@/theme-patcher</annotate>  
    <annotate key="org.freedesktop.policykit.imply">org.freedesktop.accounts.user-administration</annotate>  
  </action>

</policyconfig>
