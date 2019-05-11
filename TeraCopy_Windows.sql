-- https://www.stark4n6.com/2018/11/teracopy-forensic-analysis-part-1.html
-- https://www.stark4n6.com/2018/11/teracopy-forensic-analysis-part-2.html

SELECT 
name,  -- dB stored at  C:\Users\<USERNAME>\AppData\Roaming\Teracopy\History
datetime(julianday(started)) AS OP_START,
CASE operation
  WHEN 1 THEN 'Copy'
  WHEN 2 THEN 'Move'
  WHEN 3 THEN 'Test'
  WHEN 6 THEN 'Delete'
END AS OP_TYPE,
source,
target,
files,
size
FROM List
ORDER BY OP_START