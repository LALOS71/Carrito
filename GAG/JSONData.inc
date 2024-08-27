<%
Function JSONData(ByVal rs, ByVal labelName, ByVal nodo)'Converts recordset to JSON data
		Dim data, columnCount, colIndex, rowIndex, rowCount, rsArray
		
		if nodo<>"NO" then
			data = """" & labelName & """" & ":["
		end if
			
		If Not rs.EOF Then
			rsArray = rs.GetRows() 
			rowIndex = 0
		
			' Retrieve the total no. of rows (second dimension of the array)
			rowCount = ubound(rsArray,2)
			'Retrive the total no. of columns/fields (first dimension of the array)
			columnCount = ubound(rsArray,1)
			'Loop through the array holding the resultset and display records 
			'Loop through rows as the outer loop
			For rowIndex = 0 to rowCount
				data = data & "{"
			   'Loop through columns/fields as inner loop
			   For colIndex = 0 to columnCount
					data = data &  """" & rs.Fields(colIndex).Name & """" & ":""" & rsArray(colIndex,rowIndex) & """"
					If colIndex < columnCount Then
						data = data & ","
					End If
			   Next 'Move on to next column/field is there is one
			   data = data & "}"
			   If rowIndex < rowCount Then
					data = data & ","
			   End If
			Next 'Move on to next row if there is one
			
			rs.Close
		End If
		
		if nodo<>"NO" then
			data = data & "]"
		end if

		JSONData = data
	End Function



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Example usage:

'Set rs = Server.CreateObject("ADODB.recordset")
'rs.Open "SELECT Name, Age, Gender FROM Persons", conn
'Response.ContentType = "application/json"
'Response.Write "[{" & JSONData(rs, "List") & "}]"



'Example output:
'[{"List":[{"Name":"Michael","Age":"25","Gender":"Male"},{"Name":"Jane","Age":"21","Gender":"Female"}]}]


%>