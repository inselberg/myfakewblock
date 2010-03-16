
str="Couc|cffde6b43(4736) Ben normalement"
str="Couc"

nick=str
print(str)
p=string.find(str,'|')
if p ~= nil then nick=string.sub(str,1,p-1);end
print(nick)
