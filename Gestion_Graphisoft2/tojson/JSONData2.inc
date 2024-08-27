<%
Function JSONData_cmb(ByVal rs)'Converts recordset to JSON data
		Dim data, columnCount, colIndex, rowIndex, rowCount, rsArray
		
		data=""	
		If Not rs.EOF Then
			rsArray = rs.GetRows() 
			rowIndex = 0
		
			' Retrieve the total no. of rows (second dimension of the array)
			rowCount = ubound(rsArray,2)
			For rowIndex = 0 to rowCount
				data = data & """" & rsArray(colIndex,rowIndex) & """"
				If rowIndex < rowCount Then
					data = data & ","
				End If
			Next 'Move on to next row if there is one
			rs.Close
		End If
		JSONData_cmb = data
	End Function

%>