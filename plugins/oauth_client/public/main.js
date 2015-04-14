function oauthPluginCloseLoginPopup(loggedIn, privateToken) {
  if (window.opener && typeof window.opener.oauthPluginHandleLoginResult == 'function') {
    try {
      window.opener.oauthPluginHandleLoginResult(loggedIn, privateToken);
    } catch (err) {}
    window.close();
  }
  return false;
}
