local json = {}

do
  local math, string, table = require'math', require'string', require'table'
  local math_floor, math_max, math_type = math.floor, math.max, math.type or function() end
  local string_char, string_sub, string_find, string_match, string_gsub, string_format
      = string.char, string.sub, string.find, string.match, string.gsub, string.format
  local table_insert, table_remove, table_concat = table.insert, table.remove, table.concat
  local type, tostring, pairs, assert, error = type, tostring, pairs, assert, error
  local loadstring = loadstring or load

  local null = {"This Lua table is used to designate JSON null value, compare your values with json.null to determine JSON nulls"}
  json.null = setmetatable(null, {
      __tostring = function() return 'null' end
  })

  local empty = {}
  json.empty = setmetatable(empty, {
      __tostring = function() return '{}' end,
      __newindex = function() error("json.empty is an read-only Lua table", 2) end
  })

  local encodeString
  local isArray
  local isEncodable
  local isConvertibleToString
  local isRegularNumber

  function json.encode(obj)
      if obj == nil or obj == null then
        return 'null'
      end

      if obj == empty then
        return '{}'
      end

      local obj_type = type(obj)

      if obj_type == 'string' then
        return '"'..encodeString(obj)..'"'
      end

      if obj_type == 'boolean' then
        return tostring(obj)
      end

      if obj_type == 'number' then
        assert(isRegularNumber(obj), 'numeric values Inf and NaN are unsupported')
        return math_type(obj) == 'integer' and tostring(obj) or string_format('%.17g', obj)
      end

      if obj_type == 'table' then
        local rval = {}
        local bArray, maxCount = isArray(obj)
        if bArray then
            for i = obj[0] ~= nil and 0 or 1, maxCount do
              table_insert(rval, json.encode(obj[i]))
            end
        else
            for i, j in pairs(obj) do
              if isConvertibleToString(i) and isEncodable(j) then
                  table_insert(rval, '"'..encodeString(i)..'":'..json.encode(j))
              end
            end
        end
        if bArray then
            return '['..table_concat(rval, ',')..']'
        else
            return '{'..table_concat(rval, ',')..'}'
        end
      end

      error('Unable to JSON-encode Lua value of unsupported type "'..obj_type..'": '..tostring(obj))
  end

  local function create_state(s)
      local state = {disp = 0}
      if type(s) == "string" then
        state.part = s
      else
        state.part = ""
        state.more = s
      end
      return state
  end

  local escapeList = {
        ['"']  = '\\"',
        ['\\'] = '\\\\',
        ['/']  = '\\/',
        ['\b'] = '\\b',
        ['\f'] = '\\f',
        ['\n'] = '\\n',
        ['\r'] = '\\r',
        ['\t'] = '\\t',
        ['\127'] = '\\u007F'
  }
  function encodeString(s)
      if type(s) == 'number' then
        s = math_type(s) == 'integer' and tostring(s) or string_format('%.f', s)
      end
      return string_gsub(s, ".", function(c) return escapeList[c] or c:byte() < 32 and string_format('\\u%04X', c:byte()) end)
  end

  function isArray(t)
      local maxIndex = 0
      for k, v in pairs(t) do
        if type(k) == 'number' and math_floor(k) == k and 0 <= k and k <= 1e6 then
            if not isEncodable(v) then
              return false
            end
            maxIndex = math_max(maxIndex, k)
        elseif not (k == 'n' and v == #t) then
            if isConvertibleToString(k) and isEncodable(v) then
              return false
            end
        end
      end
      return true, maxIndex
  end

  function isEncodable(o)
      local t = type(o)
      return t == 'string' or t == 'boolean' or t == 'number' and isRegularNumber(o) or t == 'nil' or t == 'table'
  end

  function isConvertibleToString(o)
      local t = type(o)
      return t == 'string' or t == 'number' and isRegularNumber(o) and (math_type(o) == 'integer' or math_floor(o) == o)
  end

  local is_Inf_or_NaN = {[tostring(1/0)]=true, [tostring(-1/0)]=true, [tostring(0/0)]=true, [tostring(-(0/0))]=true}
  function isRegularNumber(v)
      return not is_Inf_or_NaN[tostring(v)]
  end

  function split(inputstr, sep)
      local t={}
      for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
      end
      return t
  end
end


function chronos_filters(tag, timestamp, record)
  new_record = {}
  if record['message'] ~= nil and record['message']:find("^User Deprecated: ") ~= nil then
    new_record['message'] = record['message']
    new_record['datetime'] = record['datetime']
    new_record['context'] = json.encode(record['context'])
    new_record['index'] = "tiime-chronos-deprecated-logs-" .. record['kubernetes']['namespace_name']:gsub("chronos--", "")
  else
    new_record['message'] = record['message']
    new_record['datetime'] = record['datetime']
    new_record['channel'] = record['channel']
    new_record['level'] = record['level_name']
    if record['extra'] then
      new_record['throwable'] = record['extra']['throwable']
      new_record['trace_id'] = record['extra']['trace_id']
      new_record['log_id'] = record['extra']['log_id']
      new_record['domain'] = record['extra']['server']
      new_record['http_method'] = record['extra']['http_method']
      new_record['url'] = record['extra']['url']
      if record['extra']['ip'] then
        new_record['ip'] = split(record['extra']['ip'], ", ")
      end
      new_record['body'] = record['extra']['body']
      new_record['auth0_id'] = record['extra']['auth0_id']
      new_record['impersonator'] = record['extra']['impersonator']
      if record['extra']['route'] then
        new_record['route'] = json.encode(record['extra']['route'])
        new_record['route_name'] = record['extra']['route']['_route']
        new_record['company'] = record['extra']['route']['companyId']
      end
      new_record['tiime_app'] = {}
      new_record['tiime_app']['platform'] = record['extra']['tiime_app_platform']
      new_record['tiime_app']['version'] = record['extra']['tiime_app_version']
      new_record['tiime_app']['name'] = record['extra']['tiime_app_name']
      new_record['header_accept'] = record['extra']['header_accept']
    end
    if record['context'] then
      new_record['context'] = json.encode(record['context'])
      if record['context']['company'] then
        new_record['company'] = record['context']['company']
      end
      new_record['amqp'] = {}
      if record['context']['message'] then
        if record['context']['message']['body'] then
          new_record['amqp']['task_type'] = record['context']['message']['body']['type']
        end
        new_record['amqp']['message_id'] = record['context']['message']['id']
      end
      new_record['amqp']['seconds_in_queue'] = record['context']['seconds_in_queue']
      new_record['amqp']['execution_time_ms'] = record['context']['execution_time_ms']
      new_record['status_code'] = record['context']['status_code']
      new_record['response_time'] = record['context']['response_time']
      new_record['technical_debt_score'] = record['context']['technical_debt_score']
    end
    new_record['index'] = "tiime-chronos-logs-" .. record['kubernetes']['namespace_name']:gsub("chronos--", "")
  end
  new_record["kubernetes"] = {}
  new_record["kubernetes"]["container_name"] = record["kubernetes"]["container_name"]
  new_record["kubernetes"]["pod_name"] = record["kubernetes"]["pod_name"]
  if record["kubernetes"]["labels"]["job-name"] then
    new_record["kubernetes"]["job_name"] = record["kubernetes"]["labels"]["job-name"]
    new_record["kubernetes"]["cronjob_name"] = record["kubernetes"]["labels"]["job-name"]:gsub("-[^-]*$", "")
  end
  return 1, timestamp, new_record
end