<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ request.getContextPath() + "/";
	Map<String,String> pMap =(Map<String,String>) application.getAttribute("pMap");
	Set<String> keys = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=path%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	$(function () {

		// 可能性
		var json = {
<%
				for (String key : keys) {

					String value = pMap.get(key);

%>
					"<%=key%>":<%=value%>,
<%
				}
%>
		};


		// 时间控件
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		// 自动补全控件
		$("#edit-accountName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/tran/getCustomerName.do",
						{ "name" : query },
						function (data) {
							// 返回客户list
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});

		// 根据index传来的id查询交易信息
		$.ajax({
			url:"workbench/tran/getTranById.do",
			data:{
				"id":"${param.id}"
			},
			dataType:"json",
			type:"get",
			success:function (data) {
				// 回传交易对象
				// 赋值
				$("#edit-transactionOwner").val(data.owner);
				// 获取选择后的id属性值
				var id = $("option[name=user]:selected").attr("id");

				// 设置到隐藏域中
				$("#hide-edit-owner").val(id);

				$("#edit-amountOfMoney").val(data.money);
				$("#edit-transactionName").val(data.name);
				$("#edit-expectedClosingDate").val(data.expecteddate);
				$("#edit-accountName").val(data.customerid);
				$("#edit-transactionStage").val(data.stage);
				$("#edit-transactionType").val(data.type);
				$("#edit-clueSource").val(data.source);
				$("#edit-contactsName").val(data.contactsid);
				$("#edit-activitySrc").val(data.activityid);

				$("#edit-describe").val(data.description);
				$("#edit-contactSummary").val(data.contactsummary);
				$("#edit-nextContactTime").val(data.nextcontacttime);

				// 关于可能性 阶段作为键 获取可能性值
				$("#edit-possibility").val(json[data.stage]);

			}
		});

		// owner
		$("#edit-transactionOwner").change(function () {
			// 获取选择后的id属性值
			var id = $("option[name=user]:selected").attr("id");

			// 设置到隐藏域中
			$("#hide-edit-owner").val(id);

		});



		// 可能性随着阶段的改变而改变
		$("#edit-transactionStage").change(function () {
			var stage = $("#edit-transactionStage").val();
			// alert(json[stage]);
			$("#edit-possibility").val(json[stage]);
		});

		// 搜索市场活动

		$("#edit-act-modalBtn").click(function () {
			$("#findMarketActivity").modal("show");
		});

		$("#search-act").keydown(function (event) {

			if (event.keyCode == 13){

				$.get(
						"workbench/tran/getActsByName.do",
						{
							"name":$.trim($("#search-act").val())
						},
						function (data) {
							// 返回活动集合
							var html = "";
							$.each(data,function (index,value) {

								html += '<tr>';
								html += '<td><input type="radio" name="activity" value="'+value.id+'"/></td>';
								html += '<td id="n'+value.id+'">'+value.name+'</td>';
								html += '<td>'+value.startdate+'</td>';
								html += '<td>'+value.enddate+'</td>';
								// 这里和user联查
								html += '<td>'+value.owner+'</td>';
								html += '</tr>';

							});

							$("#act-list-body").html(html);


						},
						"json"
				);
				return false;
			}
		});

		$("#act-relateBtn").click(function () {
			// 保存id 并将name输出到市场活动源
			var id = $("input[name=activity]:checked").val();
			$("#hide-edit-actId").val(id);

			$("#edit-activitySrc").val($("#n"+id).html());

			// 关闭模态窗口
			$("#findMarketActivity").modal("hide");


		});


		// 搜索联系人
		$("#edit-con-modalBtn").click(function () {
			$("#findContacts").modal("show");
		});

		$("#search-contact").keydown(function (event) {
			if (event.keyCode == 13){

				// ajax查询
				$.get(
						"workbench/tran/getContactsByName.do",
						{
							"name":$.trim($("#search-contact").val())
						},
						function (data) {
							// 查询 联系人集合
							var html = "";

							$.each(data,function (index,value) {

								html += '<tr>';
								html += '<td><input type="radio" name="contact" value="'+value.id+'"/></td>';
								html += '<td id="m'+value.id+'">'+value.fullname+'</td>';
								html += '<td>'+value.email+'</td>';
								html += '<td>'+value.mphone+'</td>';
								html += '</tr>';

							});

							$("#contact-list-body").html(html);
						},
						"json"
				);
				return false;

			}
		});

		$("#contact-relateBtn").click(function () {
			// 保存id 输出name
			var id = $("input[name=contact]:checked").val();

			$("#hide-edit-conId").val(id);

			$("#edit-contactsName").val($("#m"+id).html());

			// 关闭模态窗口
			$("#findContacts").modal("hide");
		});

		// 给更新按钮绑定事件
		$("#edit-do-Btn").click(function () {
			// 设置id
			$("#tranId").val("${param.id}");

			// 设置Owner
			$("#edit-transactionOwner").val();

			// todo 更新按钮没写完

			// 提交
			$("#edit-tran-form").submit();
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
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="search-act" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="act-list-body">

						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="act-relateBtn">关联</button>
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
						    <input type="text" id="search-contact" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
						<tbody id="contact-list-body">

						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="contact-relateBtn">关联</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="edit-do-Btn">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="edit-tran-form" action="workbench/tran/editTran.do" method="post">
		<input type="hidden" id="tranId" name="id">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner">
					<option></option>
				  <c:forEach items="${userList}" var="u">
					  <option id="${u.id}" name="user">${u.name}</option>
				  </c:forEach>
				</select>
				<input type="hidden" id="hide-edit-owner" name="owner">

			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" name="name">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTime" id="edit-expectedClosingDate" name="expecteddate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-accountName" name="customerid" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="sl">
					<option>${sl.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType" name="type">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="t">
					  <option>${t.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource" name="source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="s">
					  <option>${s.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="edit-act-modalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activitySrc">
				<input type="hidden" id="hide-edit-actId" name="activityid">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="edit-con-modalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName">
				<input type="hidden" id="hide-edit-conId" name="contactsid">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactsummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTime" id="edit-nextContactTime" name="nextcontacttime">
			</div>
		</div>
		
	</form>
</body>
</html>