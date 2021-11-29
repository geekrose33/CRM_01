<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Map<String,String> pMap =(Map<String,String>) application.getAttribute("pMap");
Set<String> keys = pMap.keySet();


%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
    /*
        可能性字段是用来给用户显示的字段 不存储在数据库表中
        它和表中字段stage阶段一一对应
        stage       possibility
        key         value
        01资质审查   10
        07          100

        这种数据不存到数据库中， 数据库存储的是表数据
        这种数据：
        1. 数据量不大
        2. 键值对形式存在
        这种情况使用 properties属性文件存储最为合适
        我们通过stage 以及对应关系 来取得可能性的值
        这种需求在交易模块 需要大量使用到

        所以我们就需要将改文件解析在服务器缓存中
        application.setAttribute(Stage2Possibility.properties文件内容);

    */
	$(function () {
	var json = {

<%
			for (String stage:keys){

				String value = pMap.get(stage);
%>
			"<%=stage%>":<%=value%>,
<%
			}
%>

	};

		// 时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});


		// alert(json);
		// 为阶段变化绑定事件
		$("#create-transactionStage").change(function () {


			// alert($("#create-transactionStage").val());
			var stage = $("#create-transactionStage").val();
			// 获取json value 以前是通过 json.key获取
			// 但是这个key是变化的 不是以前固定的
			// 需要通过 json[key]形式获取
			// alert(json[stage]);
			$("#create-possibility").val(json[stage]);

		});



		// 自动补全控件
		$("#create-accountName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/tran/getCustomerName.do",
						{ "name" : query },
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});


		// 获取所有内容发送到后端 然后跳回index
		$("#search-activity-btn").click(function () {

			// 打开模态窗口
			$("#findMarketActivity").modal("show");

			// 自动聚焦
			$("#search-activity").focus();

		});

		$("#close-modal-btn").click(function () {

			// 关闭模态窗口
			$("#findMarketActivity").modal("hide");
		})

		// 展开搜索市场活动模态窗口
		$("#search-activity").keydown(function (event) {
			if (event.keyCode == 13){
				// 搜索

				$.ajax({
					url:"workbench/tran/searchActs.do",
					data:{
						"name":$.trim($("#search-activity").val())
					},
					dataType:"json",
					type:"get",
					success:function (data) {

						// 获取市场活动集合
						var html = "";
						$.each(data,function (index,value) {
							html += '<tr>';
							html += '<td><input type="radio" name="one" value="'+value.id+'"/></td>';
							html += '<td id="n'+value.id+'">'+value.name+'</td>';
							html += '<td>'+value.startdate+'</td>';
							html += '<td>'+value.enddate+'</td>';
							// 这里owner和user 联查
							html += '<td>'+value.owner+'</td>';
							html += '</tr>';
						});

						$("#search-activity-list").html(html);

					}
				});
				return false;


			}
		});
		// 给所有者填充选项（ajax从user表获取） 实现方式一
		/*$.ajax({
			url:"workbench/tran/getUsers.do",
			dataType:"json",
			type:"get",
			success:function (data) {
				var uid = "${user.id}";
				var html = "<option></option>";
				$.each(data,function (index,value) {
					html += "<option value='"+value.id+"'>"+value.name+"</option>";

				});
				$("#create-transactionOwner").html(html);
			}
		});*/

		// 点击添加市场活动按钮
		$("#addActBtn").click(function () {

			// 将选择的市场活动 名称加到搜索框
			var $act = $("input[name=one]:checked");
			var id = $act.val();


			var name = $("#n"+id).html();
			// 设置名称
			$("#create-activitySrc").val(name);

			// 保存市场活动id
			$("#hide-actId").val(id);

			// 并且关闭模态窗口
			$("#findMarketActivity").modal("hide");
		});


		// 展开搜索联系人的模态窗口
		$("#search-contact-btn").click(function () {
			// 展开模态窗口
			$("#findContacts").modal("show");
		});

		// 回车搜索联系人
		$("#search-contact").keydown(function (event) {

			if (event.keyCode == 13){

				// 搜索内容
				$.ajax({
					url:"workbench/tran/searchContacts.do",
					data:{
						"name":$.trim($("#search-contact").val())
					},
					dataType:"json",
					type:"get",
					success:function (data) {
						// 显示联系人集合
						var html = "";

						$.each(data,function (index,value) {
							html += '<tr>';
							html += '<td><input type="radio" name="two" value="'+value.id+'"/></td>';
							html += '<td id="'+value.id+'">'+value.fullname+'</td>';
							html += '<td>'+value.email+'</td>';
							html += '<td>'+value.mphone+'</td>';
							html += '</tr>';
						});

						$('#contact-list').html(html);

					}
				});

				return false;

			}

		});

		// 绑定添加联系人按钮
		$("#addContactBtn").click(function () {

			// 保存id 将名称保存到输入框
			var $contact = $("input[name=two]:checked");
			var id = $contact.val();

			$("#hide-contactId").val(id);
			$("#create-contactsName").val($("#"+id).html());

			// 关闭模态窗口
			$("#findContacts").modal("hide");

		});


		// 添加交易按钮 绑定事件
		$("#saveTranBtn").click(function () {

			/*
				需要：
				返回：直接返回index页面
			*/

			$("#create-tran-form").submit();



		});


	})


</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" id="close-modal-btn">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>

<%--				查找市场活动的模态窗口--%>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-activity" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="search-activity-list">

						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="addActBtn">添加</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-contact" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询, 回车">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contact-list">

						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="addContactBtn">添加</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="create-tran-form" action="workbench/tran/saveTran.do" method="post">
		<div class="form-group">
			<%--	隐藏域 存储添加的市场活动id 和 联系人id--%>

			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
					<option></option>
					<c:forEach items="${userList}" var="u">
						<option value="${u.id}" ${u.id eq user.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				  <%--<option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-expectedClosingDate" name="expecteddate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" name="customerid" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="s">
					<option>${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option>${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${sourceList}" var="sl">
						<option>${sl.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="search-activity-btn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
				<input type="hidden" id="hide-actId" name="activityid">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="search-contact-btn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" readonly>
				<input type="hidden" id="hide-contactId" name="contactsid">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactsummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-nextContactTime" name="nextcontacttime">
			</div>
		</div>
		
	</form>
</body>
</html>