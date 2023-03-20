local M = {}

M.get_weekday = function()
  local signs = require('utils.const').weekdays
  local daysoftheweek = { 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' }
  local day = daysoftheweek[os.date('*t').wday]
  local header = signs[day]
  local date = os.date('%Y-%m-%d %H:%M:%S')
  table.insert(header, string.rep(' ', (vim.api.nvim_strwidth(header[2]) - (vim.api.nvim_strwidth(tostring(date)) / 2) - 10) / 2) .. date)

  return header
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
M.empty = function(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

--- Remove duplicates from table
---@param tbl table
---@return table
M.unique = function(tbl)
  local seen = {}
  local result = {}
  for _, str in ipairs(tbl) do
    if not seen[str] then
      table.insert(result, str)
      seen[str] = true
    end
  end
  return result
end

return M
