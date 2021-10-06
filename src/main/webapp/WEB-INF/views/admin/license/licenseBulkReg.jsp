<%--
  Created by IntelliJ IDEA.
  User: yong
  Date: 2021/10/03
  Time: 11:16 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/constants.jsp"%>
<%@ include file="licenseBulkReg-js.jsp"%>

<%-- 관리자 화면 템플릿 --%>
<!DOCTYPE html>
<html>
<head>
    <tiles:insertAttribute name="meta" />
    <tiles:insertAttribute name="scripts" />
</head>
<body>
<div>
    <span class="fileex_back">
        <div id="srcCsvFile">+ Add file</div>
    </span>
</div>
<div class="jqGridSet srcBtn">
    <table id="jqGrid"></table>
    <div id="srcPager"></div>
    <button type="button" id="btn">버튼</button>
</div>
</body>
</html>
<script type="text/javascript">
    var jsonData;
    var target = $("#jqGrid");
    var mainData = target.jqGrid('getGridParam','data');

    $(document).ready(function () {


        $("#jqGrid").jqGrid({
            mtype: "GET",
            datatype: "local",
            colNames:['1','2','3','4','5'],
            colModel: [
                { name: 'OrderID', 	index: 'OrderID', 	key: true, width: 75 },
                { name: 'CustomerID', index: 'Customer ID', width: 150 },
                { name: 'OrderDate', 	index: 'Order Date', 	width: 150 },
                { name: 'Freight', 	index: 'Freight', 	width: 150 },
                { name: 'ShipName', 	index:'Ship Name', 	width: 150 }
            ],
            viewrecords: true,
            height: 230,
            rowNum: 10,
            rowList:[10,20,30],
            pager: "#jqGridPager"
        });

        var url = 'http://trirand.com/blog/phpjqgrid/examples/jsonp/getjsonp.php?callback=?&qwery=longorders';
        $.getJSON(url, function(data) {
            jsonData = data.rows;
            $.each(data, function(i, item){
            });
        });

    });

    $('#btn').click(function(){

        //데이터 추가
        for(var i=0; i<jsonData.length ; i++ ){
            //console.log(i);
            $('#jqGrid').jqGrid('addRowData', i, jsonData[i]);
        }
        //다시 로드
        $("#jqGrid").trigger('reloadGrid');

        console.log(mainData);
    });

</script>
