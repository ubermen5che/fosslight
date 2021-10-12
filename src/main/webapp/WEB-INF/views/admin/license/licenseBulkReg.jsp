<%--
  Created by IntelliJ IDEA.
  User: yong
  Date: 2021/10/03
  Time: 11:16 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/constants.jsp"%>
<%@ include file="./licenseBulkReg-js.jsp"%>
<div id="wrapIframe">
    <body>
    <div>
        <span class="fileex_back">
            <div id="srcCsvFile">+ Add file</div>
        </span>
    </div>
    <div class="jqGridSet">
        <table id="list"><tr><td></td></tr></table>
        <div id="pager"></div>
    </div>
    <div class="btnLayout">
        <span class="left">
            <input type="button" id="btn" value="Bulk registration" class="btnColor red" style="width: 125px;" />
        </span>
    </div>
    </body>
</div>

