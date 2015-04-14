function oauthPluginCloseLoginPopup(loggedIn, privateToken) {
  if (window.opener && typeof window.opener.handleLoginResult == 'function') {
    try {
      window.opener.handleLoginResult(loggedIn, privateToken);
    } catch (err) {}
    window.close();
  }
  return false;
}
