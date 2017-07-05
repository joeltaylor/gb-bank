json.array! @members do |member|
  json.email member.email
  json.name member.name
  json.balance member.account.balance
end

