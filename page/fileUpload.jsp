<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>窃电用户检测系统</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">

<%
	String path = request.getContextPath();
%>

<script src="<%=path%>/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="<%=path%>/bootstrap/js/bootstrap.min.js"></script>
<!-- bootstrap-table -->
<script src="<%=path%>/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script
	src="<%=path%>/plugins/bootstrap-table/bootstrap-table-locale-all.min.js"></script>
	<script
	src="<%=path%>/plugins/mCustomScrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
	
<script
	src="<%=path%>/js/public.js"></script>	
	
	<!-- Bootstrap 3.3.6 -->
<link rel="stylesheet" href="<%=path%>/bootstrap/css/bootstrap.min.css">
<!-- bootstrap-table -->
<link rel="stylesheet"
	href="<%=path%>/plugins/bootstrap-table/bootstrap-table.min.css">
	
	<link rel="stylesheet"
	href="<%=path%>/plugins/mCustomScrollbar/jquery.mCustomScrollbar.css">
	
 <link rel="stylesheet"
	href="<%=path%>/css/public.css">
<style>
body
  {
  background-image: url(../img/uploadimg/bg3.png);
  background-repeat: no-repeat;
  font-size:14px;
  text-align:center;
  background-size:cover;  
  }
  
 input{ vertical-align:middle; margin:0; padding:0}
.file-box{ position:relative;width:440px}
.txt{ height:22px; border:1px solid #cdcdcd; width:180px;}
.btn{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:70px;}
.file1{ position:absolute; top:0; left:100px; height:40px; filter:alpha(opacity:0);opacity: 0;width:76%; }
.file2{ position:absolute; top:45px; left:100px; height:40px; filter:alpha(opacity:0);opacity: 0;width:76%; }
.file3{ position:absolute; top:90px; left:100px; height:40px; filter:alpha(opacity:0);opacity: 0;width:76%; }

#divcss5
{
  width:40%;  
  height:auto; 
  margin: 18% auto; 
  min-width:700px;
  padding-left:100px;
} 
#fileform1:after {
	content:'';
	display:block;
	height:0;
	visibility:hidden;
	clear:both;
}

/* #fileform1 input[type='button'] {
	margin-left:1%;
	width:10%;
	height:40px;
	float:left;
} */

 #fileform1 input[type='button'] {
	float:left;
} 

input[type='button'] {
	margin-left:1%;
	width:10%;
	height:40px;
}
#datadiv
{
  position:absolute; 
  left:20%;  
  top:55%;  
}



a:link { 
color:#FFFFFF; 
text-decoration:none; 
} 

a:visited { 
color:yellow; 
text-decoration:none; 
} 

a:hover { 
color:#fdae61; 
text-decoration:none; 

} 

a:active { 
color:#000000; 
text-decoration:none; 
} 

a{text-decoration:none}

.bootstrap-table {
	height:100% !important;
}
.fixed-table-container {
	height:100% !important;
}
.fixed-table-body {
	height:calc(100% - 40px);
}


span img{
margin-left: 20px;

}



#bannerDiv
{
    position:absolute;
    top:30px;
    left:30px;
    background-image:url("<%=path%>/img/login/banner.png"); 
    width: 100%;
    height: 100px;
    z-index: 9999999;
    background-repeat: no-repeat;
}

.logout{
position: absolute;
    top: 40px;
    right: 50px;
    }

</style>

<script>

function logout(){
      	$.ajax({
			url: '<%=path%>' + "/loginAction/loginOut.do",
			dataType : "json", // 返回格式为json
			async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
			type : "post", // 请求方式，查询
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			beforeSend : showAnalysisLoading,
			success : function(data) 
			{
	            console.log(data);
			    if(data.resultCode == "200")
			    {
			         window.location.href="<%=path%>";
			    }
			    else 
			    {
			        showErrorMsg(data.msg);
			    }
			    
                 
			},
			complete : function() {
				hideLoading();
			}
		}); 
      }


var errinfoBeanList;
var fileId = 1;

 function doUpload() {  
     
     
      var filepath1 = $("#textfield1").val();
      if(filepath1 == "" || filepath1 == null || filepath1 == undefined)
      {
          showErrorMsg("请上传用电量数据");
          return false;
      }
     
     
     //上传文件不是zip格式的文件
     if(filepath1.toLowerCase().lastIndexOf('.zip') == -1)
     {
         showErrorMsg("用电量数据文件类型不正确，请上传zip格式的文件");
         return false;
     }
     
     
      var filepath2 = $("#textfield2").val();
      if(filepath2 == "" || filepath2 == null || filepath2 == undefined)
      {
          showErrorMsg("请上传线损数据");
          return false;
      }
      
       //上传文件不是zip格式的文件
     if(filepath2.toLowerCase().lastIndexOf('.zip') == -1)
     {
         showErrorMsg("线损数据文件类型不正确，请上传zip格式的文件");
         return false;
     }
      
      var filepath3 = $("#textfield3").val();
      if(filepath3 == "" || filepath3 == null || filepath3 == undefined)
      {
          showErrorMsg("请上传用户台区对应关系数据");
          return false;
      }
      
      
      
     //上传文件不是zip格式的文件
     if(filepath3.toLowerCase().lastIndexOf('.zip') == -1)
     {
         showErrorMsg("用户台区对应关系数据文件类型不正确，请上传zip格式的文件");
         return false;
     }
     
    /*  var filepath1 = $("#textfield").val();
     
      $("#errorMsg").hide();
      $("#errorMsgList").hide();
      $("#datadiv").hide();
     

     if(filepath1 == "" || filepath1 == null || filepath1 == undefined)
     {
         showErrorMsg("请选择要上传的文件");
         return false;
     }
     
     
     var spannum = $('#fileListDiv').children('span').length;
     if(spannum > 10)
     {   
         showErrorMsg("一次最多上传10个文件");
         return false;
     }
     
     //上传文件不是excel格式的文件
     if((filepath1.toLowerCase().lastIndexOf('.xlsx') == -1) && (filepath1.toLowerCase().lastIndexOf('.xls') == -1))
     {
         showErrorMsg("文件类型不正确，请上传excel格式的文件");
         return false;
     } */
   
     //showLoading();
     var formData = new FormData($( "#fileform1")[0]);  
     $.ajax({  
          url: '<%=path%>/fileUploadAction/springUpload.do' ,  
          type: 'POST',  
          data: formData,  
          async: true,  
          cache: false,  
          contentType: false,  
          processData: false,  
          beforeSend:showLoading,
          success: function (result) {
              if(result.code == 200)
              { 
                  uploadFileFlag = true;
                  
                  $("#errorMsg").hide();
                  setTimeout("alert('文件上传成功')",300);
                              
   <%--                $("#downloadtemp").hide();
                  
                  //alert();
                  
                  $("#fileListDiv").show();
     
                  $("#textfield").val("");
                  
                  var oneFile =  '<span id="span' + fileId+ '"><font  color="#312828"  size="3px"> ' + result.fileName + ' </font><img fileName= ' + result.fileName + ' onclick=deletspan(this) width="20px" height="15px" src="<%=path%>/img/uploadimg/delete.png"></img><br></span>' 
                  fileId++;
                  $("#fileListDiv").append(oneFile); --%>
                  
                         
                  
                    //$("#sucessto").show();
                  
                   //setTimeout("forwordto()",1000);
           
                  
                  //alert("201");
                  //$("#msgspan").html("上传文件成功！正在跳转~");
              }
              //请使用正确的模板上传
              else if(result.code == 401)
              {
                 showErrorMsg(result.msg);  
              }
              //上传失败！查看详情
              else if(result.code == 402)
              {
                  $("#errorMsgList").show();
                  errinfoBeanList = result.errorRowlist;
                  initydTable();
              }
              //excel里没有数据
              else if(result.code == 403)
              {
                  showErrorMsg(result.msg);  
              }
              
          },  
          error: function (result) {  
              alert(result.msg);  
          },
		 complete:function()
		 {
             hideLoading();
		 }  
     });  
} 


function deletspan(obj)
{
          if(!confirm("是否删除该文件？"))
          {
              return false;
          }
          
         
          var fileName =  $(obj).prev().text();
          //alert(fileName);
      
          $.ajax({
			url: '<%=path%>' + "/fileUploadAction/deleteOneFile.do",
			dataType : "json", // 返回格式为json
			data:{"deleteFileName":fileName},
			async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
			type : "post", // 请求方式，查询
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			beforeSend : showLoading,
			success : function(data) 
			{
	            //console.log(data);
			    if(data.code == "200")
			    {
                    $(obj).parent().remove();
                    fileId--;
			    }
			    else 
			    {
			        showErrorMsg(data.msg);
			    }
			    
                 
			},
			complete : function() {
				hideLoading();
			}
		}); 
}


var uploadFileFlag = false;

function tofenxi() 
{  

  if(!uploadFileFlag)
  {  
      showErrorMsg("请先上传文件");       
      return false;
  
  }
  //alert(uploadFileFlag);

  /*   var spannum = $('#fileListDiv').children('span').length;
    //alert(spannum);
    if(spannum <= 1)
    {
        showErrorMsg("请先上传文件");
        return false;
    }   
    else
    { */
        $.ajax({
			url: '<%=path%>' + "/fileUploadAction/toFenXi.do",
			dataType : "json", // 返回格式为json
			async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
			type : "post", // 请求方式，查询
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			beforeSend : showAnalysisLoading,
			success : function(data) 
			{
	            console.log(data);
			    if(data.code == "200")
			    {
			    	hideLoading();
			         $("#errorMsg").hide();  
			                
                    setTimeout("forwordto()",300);
			    }
			    else 
			    {
			        showErrorMsg(data.msg);
			    }
			    
                 
			},
			complete : function() {
				hideLoading();
			}
		}); 
/*     } */


  

} 


function showErrorMsg(msg)
{
    $("#errorMsg").show();
    $("#errorMsgtext").text(msg);
}


function forwordto()
{
    alert("分析成功");     
    
	setTimeout("jump()",300);
}

function jump(){
	$("#sucessto").show();  
    window.location.href='<%=path%>/page/main.jsp';
}



   function UpladFile() {
            var fileObj = document.getElementById("file").files[0]; // js 获取文件对象
            var FileController = "<%=path%>/fileUploadAction/springUpload.do";                    // 接收上传文件的后台地址 

            // FormData 对象
            var form = new FormData($( "#fileform1" )[0]);

            // XMLHttpRequest 对象
            var xhr = new XMLHttpRequest();
            xhr.open("post", FileController, true);
            xhr.onload = function () {
               // alert("上传完成!");
            };

            xhr.upload.addEventListener("progress", progressFunction, false);
            xhr.send(form);
        }

        function progressFunction(evt) {
            var progressBar = document.getElementById("progressBar");
            var percentageDiv = document.getElementById("percentage");
            if (evt.lengthComputable) {
                progressBar.max = evt.total;
                progressBar.value = evt.loaded;
                percentageDiv.innerHTML = Math.round(evt.loaded / evt.total * 100) + "%";
                if(evt.loaded==evt.total){
                    alert("上传完成100%");
                }
            }
        }
        
        
        
    $(function()
    {
           $.ajax({
			url: '<%=path%>' + "/fileUploadAction/clearSession.do",
			dataType : "json", // 返回格式为json
			async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
			type : "post", // 请求方式，查询
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			success : function(data) 
			{			    
                 
			},
			complete : function() {

			}
		}); 
    });   
    
    
    function initydTable() {
		//初始化表格,动态从服务器加载数据
		$("#ydTable").bootstrapTable('destroy').bootstrapTable({
			height : 475,
			//search : true,
			data: errinfoBeanList,
			method : "get", //使用get请求到服务器获取数据
			//url : '<%=path%>' + "/json/data1.json", //获取数据的Servlet地址
				striped : true, //表格显示条纹
				locale : "zh-CN", //表格汉化
				pagination : false, //启动分页
				queryParams : function queryParams(params) { //设置查询参数
					var param = {
						pageNumber : params.pageNumber,
						pageSize : params.pageSize
					};
					return param;
				}
			});
			
			/* setTimeout(setmCustomScrollbar,100);
			
			function setmCustomScrollbar(){
				$(".fixed-table-container").mCustomScrollbar({
					scrollButtons:{
						enable:true
					}
				});
				$(".fixed-table-container").css("padding","0px");
			} */
	}    
	
	
	function showerrormsg()
	{
	var div = $('#errorMsgList');
	var top = div.offset().top,h = div.height();
		$("#datadiv").css('top',(top + h + 10) + 'px');
	     $("#datadiv").toggle();
	
	}
	
	
	function fileclick()
	{
	
	    var test1 = document.getElementById('fileField').value
	    //var test2 = document.getElementById('textfield').value
	    alert(test1);

	    //document.getElementById('textfield').value=this.value;	
	}
	
	function getFilePath(node){  
	    var imgURL = "";
	    try{
	        var file = null;
	        if(node.files && node.files[0] ){
	            file = node.files[0];
	        }else if(node.files && node.files.item(0)) {
	            file = node.files.item(0);
	        }
	        //Firefox 因安全性问题已无法直接通过input[file].value 获取完整的文件路径
	        try{
	            //Firefox7.0
	            imgURL =  file.getAsDataURL();
	            //alert("//Firefox7.0"+imgRUL);
	        }catch(e){
	            //Firefox8.0以上
	            imgURL = window.URL.createObjectURL(file);
	            //alert("//Firefox8.0以上"+imgRUL);
	        }
	    }catch(e){      //这里不知道怎么处理了，如果是遨游的话会报这个异常
	        //支持html5的浏览器,比如高版本的firefox、chrome、ie10
	        if (node.files && node.files[0]) {
	            var reader = new FileReader();
	            reader.onload = function (e) {
	                imgURL = e.target.result;
	            };
	            reader.readAsDataURL(node.files[0]);
	        }
	    }
	    return imgURL;

	}  
	

</script>

</head>
<body >
    <div id="bannerDiv">
    	<a href="#" onclick="logout()" class="logout">退出</a>
    </div>

<!--     <br />
    <br />
    <br />
    <br />

    <progress id="progressBar" value="0" max="100"></progress>
    <span id="percentage"></span>

    <br />
    <br />
    <br />
    <br /> -->

<div id="divcss5" class="file-box">	


  <form id="fileform1" action="" method="post" enctype="multipart/form-data">
		<span class="" style="
		    float: left;
		    font-size: 32px;
		    color: #ff0000;
		    position: absolute;
		    top: 5px;
		    left: 70px;
		">*</span>
		<span class="" style="
		    float: left;
		    font-size: 32px;
		    color: #ff0000;
		    position: absolute;
		    top: 55px;
		    left: 70px;
		">*</span>
		<span class="" style="
		    float: left;
		    font-size: 32px;
		    color: #ff0000;
		    position: absolute;
		    top: 105px;
		    left: 70px;
		">*</span>
      <input type='text' placeholder="上传用电量数据" name='textfield1' id='textfield1' class='txt'  style="width:65%;height:40px;padding: 0 5px 0 20px;font-size:18px;line-height:40px;float:left;"/>  
      <input type='button' class='btn' value='浏览...' />
      <input type="file" id="file1" name="fileField1" class="file1" size="28" onchange="document.getElementById('textfield1').value=this.value.substring(this.value.lastIndexOf('\\')+1);" />
		
    
      <input type='text' placeholder="上传线损数据" name='textfield2' id='textfield2' class='txt'  style="width:65%;height:40px;padding: 0 5px 0 20px;font-size:18px;line-height:40px;float:left;margin-top: 10px;"/>  
      <input type='button' class='btn' value='浏览...' style="margin-top: 10px;" />
      <input type="file" id="file2" name="fileField2" class="file2"  size="28" onchange="document.getElementById('textfield2').value=this.value.substring(this.value.lastIndexOf('\\')+1);" style="margin-top: 10px;" />

 
      <input type='text' placeholder="上传用户台区对应关系" name='textfield3' id='textfield3' class='txt'  style="width:65%;height:40px;padding: 0 5px 0 20px;font-size:18px;line-height:40px;float:left;margin-top: 10px;"/>  
      <input type='button' class='btn' value='浏览...' style="margin-top: 10px;"/>
      <input type="file" id="file3" name="fileField3" class="file3" size="28" onchange="document.getElementById('textfield3').value=this.value.substring(this.value.lastIndexOf('\\')+1);" style="margin-top: 10px;"/>


  </form>
  <br>
  
  <div style="text-align:left;">
        <input type="button" name="shangchuan" onclick="doUpload()"   class="btn" value="上传" style="margin-left: 19%;width: 100px;" />
        <input type="button" name="shangchuan" onclick="tofenxi()"   class="btn" value="分析" style="margin-left:30px;width: 100px;"/>
  </div> 
   
   <span id="sucessto" style="display:none;"><font  color="white" size="4px">正在跳转 ~ 
   <img width="20px" height="20px" src="<%=path%>/img/uploadimg/jump.png"></img>
   </font>   
   </span>
   
   <div style="text-align:center;">
       <span id="errorMsg" style="display:block;margin-top: 10px;margin-left: -100px;"><font  color="red"  size="4px" id="errorMsgtext"></font>      
       </span>
   </div>
   
   <div id="fileListDiv" style="display:none ;width: 100%;height: 100%" >
       <span id="span0"><font  color="white" size="4px"> 已上传文件： </font></span><br>
   </div>
   
   
   <br>
   <span id="errorMsgList" onclick="showerrormsg()" style="display:none;"><font color="red" size="4px">上传失败！查看详情~ &nbsp;</font><img width="20px" height="20px" src="<%=path%>/img/uploadimg/downarrow.png"></img></span>
</div>  
<!-- 
				 	<div class="col-md-8" id="datadiv" style="display:none;">
						<div class="row">
								<div class="box"
									style="width: calc(100% - 0px);height:300px;padding:10px;background-color:#424066;">
									<table id="ydTable" style="background-color:#d6b5f9"
										data-toggle="table" data-show-export="true">
										<thead  style="background-color:#d6b5f9">
											<tr>
											    <th data-field="xh" data-sortable="true">序号</th>
											    <th data-field="tqbh">台区编号</th>
												<th data-field="tqmc">台区名称</th>
												<th data-field="dq">地区</th>
												<th data-field="gds">供电所</th>
												<th data-field="dbbh">电表编号</th>
												<th data-field="yhbh">用户编号</th>
												<th data-field="yhmc">用户名称</th>								
												<th data-field="yddz">用电地址</th>
												<th data-field="yhlx">用户类型</th>
												<th data-field="rq">日期</th>
												<th data-field="dl">电量</th>
												<th data-field="errormsg">失败原因</th>
											    
											
											<th data-field="id" data-sortable="true">户号</th>
												<th data-field="name">用户名称</th>
												<th data-field="price">用电地址</th>
												<th data-field="khdymc">用电类型</th>
												<th data-field="bdzmc">台区编号</th>
												<th data-field="xlmc">台区名称</th>
												<th data-field="zhbl">用电量类别</th>
												<th data-field="jmhs">用户行为类别</th>
												<th data-field="fjmhs">结论</th>
											</tr>
										</thead>
									</table>
								</div>				
						</div>
					</div> -->

<div id="msg1">
<span id="msgspan"> <span>
</div>
	
</body>
<script>
$("#textfield1").val("");
$("#textfield2").val("");
$("#textfield3").val("");
</script>

</html>
