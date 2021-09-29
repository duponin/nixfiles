{ ... }:

{
  services.postgresql.enable = true;
  services.postgresql.authentication.authentication = ''
    host all all 127.0.0.1/32 trust
    host all all ::1/128      trust
  '';
}
