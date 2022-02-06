if !@images.empty? && !@images.last_page?
  json.has_next true
  json.next @images.next_page
else
  json.has_next false
  json.next nil
end
