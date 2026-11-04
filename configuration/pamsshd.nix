{
  security.pam.services.sshd.text = ''
    #%PAM-1.0
    # Authentication
    auth     required pam_unix.so

    # Account
    account  required pam_unix.so

    # Password (allow null passwords if present, use yescrypt)
    password sufficient pam_unix.so nullok yescrypt

    # Session
    session  required pam_env.so conffile=/etc/pam/environment readenv=0
    session  required pam_unix.so
    session  required pam_loginuid.so
    session  optional pam_systemd.so
    '';
}
