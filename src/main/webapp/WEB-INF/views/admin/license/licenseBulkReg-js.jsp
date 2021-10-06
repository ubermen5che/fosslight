<%--
  Created by IntelliJ IDEA.
  User: yong
  Date: 2021/10/04
  Time: 11:53 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/constants.jsp"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
    $(document).ready(function()
    {
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
                var result = jQuery.parseJSON(data);

                console.log(result);
                if(result[1] == null){
                    alertify.error('<spring:message code="msg.common.valid" />', 0);

                    $('.ajax-file-upload-statusbar').fadeOut('slow');
                    $('.ajax-file-upload-statusbar').remove();
                } else {
                    if(result[0] == "FILE_SIZE_LIMIT_OVER"){
                        alertify.alert(result[1], function(){
                            $('.ajax-file-upload-statusbar').fadeOut('slow');
                            $('.ajax-file-upload-statusbar').remove();
                        });
                    } else {
                        if(result[1].length != 0){
                            $('.sheetSelectPop').show();
                            $('.sheetSelectPop .sheetNameArea').children().remove();
                            $('.sheetSelectPop .sheetNameArea').text('');

                            for(var i = 0; i < result[1].length; i++){
                                var num = i+1;

                                $('.sheetSelectPop .sheetNameArea').append('<li><input type="checkbox" name="sheetNameSelect" value="'+result[1][i].no+'" id="sheet'+result[1][i].no+'" class="sheetNum">'
                                    +'<label for="sheet'+result[1][i].no+'">'+result[1][i].name+'</label></li>');
                                $('.sheetSelectPop .sheetApply').attr('onclick', 'src_fn.getSheetData('+result[0][0].registSeq+')');
                            }
                        }

                        $('#srcCsvFileId').val(result[0][0].registFileId);
                        $('.ajax-file-upload-statusbar').fadeOut('slow');
                        $('.ajax-file-upload-statusbar').remove();

                        src_fn.makeFileTag(result[0][0]);
                    }
                }
            }
        });
    });
</script>
