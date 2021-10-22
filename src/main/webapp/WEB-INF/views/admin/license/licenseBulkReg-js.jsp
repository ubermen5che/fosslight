<%--
  Created by IntelliJ IDEA.
  User: yong
  Date: 2021/10/04
  Time: 11:53 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/constants.jsp"%>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/jqgrid4.7/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" href="/css/commonIframe.css?${cssVersion}" />
<link rel="stylesheet" type="text/css" href="/css/uploadFile/uploadfile.css" />
<link rel="stylesheet" type="text/css" href="/css/jquery.qtip.css" />

<script type="text/javascript" src="/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/js/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/i18n/grid.locale-en.js"></script>
<script type="text/javascript" src="/js/uploadFile/jquery.uploadfile.min.js"></script>
<script type="text/javascript" src="/js/jquery.qtip.js"></script>

<script type="text/javascript" src="/js/jquery.form.min.js"></script>
<script type="text/javascript" src="/js/basic.js?${jsVersion}"></script>

<script type="text/javascript" src="/js/jqgrid4.7/js/jquery.jqGrid.js?${jsVersion}"></script>
<script type="text/javascript" src="/js/ckeditor/ckeditor.js?${jsVersion}"></script>
<script type="text/javascript" src="/js/basic_editor.js?${jsVersion}"></script>

<!-- alertify -->
<script type="text/javascript" src="/js/alertifyjs/alertify.min.js"></script>

<link rel="stylesheet" type="text/css" href="/js/alertifyjs/css/alertify.min.css" />
<link rel="stylesheet" type="text/css" href="/js/alertifyjs/css/themes/default.min.css" />
<script>
    var jsonData;
    var withStatus;
    var loadedInfo;
    var licenseData = [];
    var isClicked = false;

    function refreshGrid($grid, results) {
        $grid.jqGrid('clearGridData')
            .jqGrid('setGridParam', { data: results })
            .trigger('reloadGrid', [{ page: 1}]);
    }

    function showErrorMsg() {
        alertify.error('<spring:message code="msg.common.valid" />', 0);

        $('.ajax-file-upload-statusbar').fadeOut('slow');
        $('.ajax-file-upload-statusbar').remove();
    }
    function stubColData(){
        //데이터 추가
        for(var i=0; i<jsonData.length ; i++ ){
            withStatus = jsonData[i]['license'];
            withStatus['status'] = jsonData[i]['status'];
            $('#list').jqGrid('addRowData', i, withStatus);
        }
        //다시 로드
        $("#list").trigger('reloadGrid');
    }

    function makeLicenseDTOList() {
        for (var i = 0; i < jsonData.length; i++){
            licenseData.push(jsonData[i]['license']);
        }
        console.log(licenseData);
    }
    function checkLoaded(){
        $("#list").jqGrid('clearGridData');
        for (var i=0; i < loadedInfo.length; i++){
            for (var j = 0; j < jsonData.length; j++){
                if (jsonData[j]['license']['licenseName'] === loadedInfo[i]['licenseName']){
                    jsonData[j]['status'] = 'loaded';
                    break;
                }
            }
        }
        stubColData();
        $("#list").trigger('reloadGrid');
    }
    $(document).ready(function()
    {
        var target = $("#list");

        if (isClicked == false) {
            isClicked = true;
            $("#btn").click(() => {
                $.ajax({
                    type: "POST",
                    contentType: 'application/json',
                    url: "/license/bulkRegAjax",
                    data: JSON.stringify(licenseData),
                    dataType: "json",
                    success: (data) => {
                        if (data['res'] == 'true' && data['value'] != []) {
                            loadedInfo = data['value'];
                            console.log(data);
                            checkLoaded();
                        } else if (data['res'] == 'false') {
                            showErrorMsg();
                        }
                    },
                    error: (e) => {
                        console.log(e);
                    }
                })
            })
        }

        $("#list").jqGrid({
            datatype: "local",
            data : jsonData,
            colNames:['id', 'License Name','License Type','Restriction','Obligation','Short Identifier','NickName','Web site for the license','License Text',
            'Attribution','Comment', 'Status'],
            colModel: [
                { name: 'id', 	index: 'id', width: 75, key:true, hidden: true},
                {name: 'licenseName', index: 'licenseName', width: 200, align: 'left'},
                { name: 'licenseType', index: 'licenseType', width: 100, align: 'center'},
                { name: 'restriction', 	index: 'restriction', 	width: 150, align: 'center'},
                { name: 'obligation', index: 'obligation', width: 200, align: 'left'},
                { name: 'shortIdentifier', index: 'shortIdentifier', width: 100, align: 'left'},
                { name: 'nickname', index:'nickName', width: 150, align: 'left'},
                { name: 'webpage', index:'webpage', width: 150, align: 'left'},
                { name: 'licenseText', index:'licenseText', width: 150, align: 'left'},
                { name: 'attribution', index:'attribution', width: 150, align: 'left'},
                { name: 'comment', index:'comment', width: 150, align: 'left'},
                { name: 'status', index:'status', width: 150, align: 'left'}
            ],
            viewrecords: true,
            rowNum: 10,
            rowList:[20,40,60],
            autowidth: true,
            gridview: true,
            height: 'auto',
            pager: "#jqGridPager"
        });

        $(window).resize(function(){
            $('jqGrid').setGridWidth($this.width()*.100);
        })

        $('#srcCsvFile').uploadFile({
            url:'/license/csvFile',
            multiple:false,
            dragDrop:true,
            fileName:'myfile',
            sequential:true,
            sequentialCount:1,
            dynamicFormData: function(){
                var data ={ "registFileId" :$('#srcCsvFileId').val(), "tabNm" : "BULK"}

                return data;
            },
            onSuccess:function(files,data,xhr,pd) {
                if (data['res'] == 'true'){
                    jsonData = data['value'];
                    makeLicenseDTOList();
                    console.log(jsonData);
                    stubColData();
                    loading.hide();
                }
                else if(data['res'] == 'false'){
                    showErrorMsg();
                } else {
                    if (data['limitCheck'] == null) {
                        showErrorMsg();
                    }
                }
            }
        });
    });
</script>
