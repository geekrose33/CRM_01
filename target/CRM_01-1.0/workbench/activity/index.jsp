<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basepath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basepath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<%--引入分页插件--%>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	$(function(){
		// 加入Bootstrap为我们提供的时间控件
		// 这里我们使用的是.class选择器 因为除了开始时间还要对结束时间添加

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		
		$("#addBtn").click(function () {




			// alert(123);
			// 走后台 打开模态窗口前将user表数据加到所有者下拉列表中
			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					// 获取List<User>
					// data {{user1},{user2},...}
					var html = "<option></option>";
					// 遍历出来的每一个value 即 user对象
					$.each(data,function (index,val) {
						// 给用户显示的是姓名 保存的是Id
						html += "<option value='"+val.id+"'>" + val.name + "</option>"
					})
					$("#create-marketActivityOwner").html(html);

					// 将所有人默认为当前登录用户的名字
					// $("#xxx").val(这里参数使用对应下拉option的value值)
					var uid = '${user.id}';
					<%--'${user.id}'--%>
					$("#create-marketActivityOwner").val(uid);

					// 打开模态窗口 方法：modal()   属性：show / hide
					$("#createActivityModal").modal("show");
				}
			});


		});

		// 为保存按钮添加事件 执行添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					"owner":$.trim($("#create-marketActivityOwner").val()),
					"name":$.trim($("#create-marketActivityName").val()),
					"startdate":$.trim($("#create-startTime").val()),
					"enddate":$.trim($("#create-endTime").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-describe").val())
				},
				dataType:"json",
				type:"post",
				// contentType:"application/json",
				success:function (data) {
					// 添加修改删除使用post 登录验证的查询使用post 剩下的使用get
					// data {"success":true / false}
					if (data.success){
						// 添加成功
						// 刷新市场活动列表 局部刷新


                        // 清除添加操作的数据
                        /*
                            当jquery的form表单对象 提交数据时 有submit()方法
                            此时进行重置 idea提示有reset()方法 注意：jQuery没有为我们提供reset
                            但是原生js有reset方法，我们将jquery对象改为dom即可
                            jquery -> dom ：数组下标
                            dom -> jquery ：$(dom)
                        */
                        $("#activityAddForm")[0].reset();

						// 关闭添加操作的模态窗口
						$("#createActivityModal").modal("hide");
						// pageList(1,5);

						// 添加操作后也是跳转到第一页 维持每页记录数
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						// 添加失败



					}
				}
			})
		});

		$("#searchBtn").click(function () {
			/*$.ajax({
				url:"workbench/activity/searchActivties.do",
				data:{
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"startdate":$.trim($("#search-startTime").val()),
					"enddate":$.trim($("#search-endTime").val()),
				},
				dataType:"get",
				type:"json",
				success:function (data) {

				}
			})*/

			/*
				解决输入框内输入数据后 点击下方分页按照输入框查询的bug
				将输入框内的数据在点击查询后保存到隐藏域中
				在分页查询时使用的是隐藏域的数据
			*/
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startTime").val()));
			$("#hidden-endDate").val($.trim($("#search-endTime").val()));
			pageList(1,5);
		});

		// 每一次加载都要刷新一次列表
		pageList(1,5);
		$("#checkbox-all").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});

		/*
			动态生成的元素，我们要以on的方式触发事件 不能用普通绑定事件的方式
			语法：
				$(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
		*/
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			$("#checkbox-all").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length );
		})

		// 实现删除按钮
		// 参数为选择的id 这里参数id key值重复 不能使用json格式
		// 这里使用字符串拼接
		$("#deleteBtn").click(function () {
			// 这里获取的是jquery对象 不能直接获取其值 需要转为dom对象
			var $ones = $("input[name=xz]:checked");
			if ($ones.length == 0){
				alert("请选择要删除的记录");
			}else {
				if (confirm("你确定要删除？")){
					var param = "";

					for (var i = 0; i < $ones.length; i++) {
						param += "id=" + $($ones[i]).val();
						if (i < $ones.length-1){
							param += "&";
						}

					}

					$.ajax({
						url:"workbench/activity/deleteActivites.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							// 回馈一个删除成功的标识即可
							if (data.success){
								//删除成功
								// pageList(1,5);
								// 删除操作后 返回第一页 维持每页记录数
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								// 删除失败



							}



						}
					})
				}

			}



		})

		// 实现修改按钮
		$("#editBtn").click(function () {
			var $ones = $("input[name=xz]:checked");

			if ($ones.length === 0){
				alert("请选择你要删除的市场活动");
			}else if ($ones.length > 1){
				alert("指定修改的市场活动不能大于1")
			}else {
				// 剩余情况就是市场活动数量为1
				var id = $ones.val();
				$.ajax({
					url:"workbench/activity/getUserListAndActivity.do",
					data:{
						"id":id
					},
					dataType:"json",
					type:"get",
					success:function (data) {
						/*
                            一共获取两个数据 UserList 和 要修改的Activity
                        */
						// userList
						var html = "";

						$.each(data.users,function (index,value) {
							html += "<option value='"+value.id+"'>" + value.name + "</option>";
						});

						$("#edit-marketActivityOwner").html(html);

						$("#edit-marketActivityName").val(data.act.name);
						$("#edit-startTime").val(data.act.startdate);
						$("#edit-endTime").val(data.act.enddate);
						$("#edit-cost").val(data.act.cost);
						$("#edit-describe").val(data.act.description);

						$("#editActivityModal").modal("show");
					}
				})

			}

		})

		// 更新操作的提交
		$("#updateBtn").click(function () {
			var $ones = $("input[name=xz]:checked");
			var id = $ones.val();
			$.ajax({
				url:"workbench/activity/updateAct.do",
				data:{
					"id":id,
					"owner":$.trim($("#edit-marketActivityOwner").val()),
					"name":$.trim($("#edit-marketActivityName").val()),
					"startdate":$.trim($("#edit-startTime").val()),
					"enddate":$.trim($("#edit-endTime").val()),
					"cost":$.trim($("#edit-cost").val()),
					"description":$.trim($("#edit-describe").val())
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					// 修改市场活动 判断标识：true / false
					if (data.success){
						// 刷新列表
						// 更新后维持 原有页数和每页记录数
						// pageList(1,5);
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						// 关闭模态窗口
						$("#editActivityModal").modal("hide");
					}else {
						alert("修改市场活动失败");
					}


				}


			})

		})

	});



	/*
	    刷新需要的地方：
	    1. 点击市场活动
	    2. 增删改
	    3. 上方条件查询
	    4. 下方分页查询
	*/
	function pageList(pageNo,pageSize) {
		// 每次刷新都将全选框的√干掉
		$("#checkbox-all").prop("checked",false);


		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startTime").val($.trim($("#hidden-startDate").val()));
		$("#search-endTime").val($.trim($("#hidden-endDate").val()));
        $.ajax({
            url:"workbench/activity/pageList.do",
            data:{
                "pageNo":pageNo,
                "pageSize":pageSize,
                "name":$.trim($("#search-name").val()),
                "owner":$.trim($("#search-owner").val()),
                "startdate":$.trim($("#search-startTime").val()),
                "enddate":$.trim($("#search-endTime").val())
            },
            type:"get",// 正常的查询数据直接用get
            dataType:"json",
            success:function (data) {
                /*
                    这里的data包含两部分
                    1. total 总记录数
                    2. activityList 活动的集合
                */
                var html = "";
                $.each(data.activityList  ,function (index,value) {
                    html += '<tr class="active">';
                    html += '<td><input type="checkbox" name="xz" value="' + value.id + '" /></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detailAct.do?id='+value.id+'\';">' + value.name + '</a></td>';
                    html += '<td>' + value.owner + '</td>';
                    html += '<td>' + value.startdate + '</td>';
                    html += '<td>' + value.enddate + '</td>';
                    html += '</tr>';
                })
				$("#activityBody").html(html);

                // 数据处理完毕后 对前端展现分页相关信息
				// 计算总页数
				var totalPages = data.totalCount % pageSize === 0 ? data.totalCount / pageSize : parseInt(data.totalCount / pageSize) + 1;
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 5, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
            }
        })
    }
	
</script>
</head>
<body>
<%--	隐藏域中存储条件查询中的数据--%>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal" role="form">

					<div class="form-group">
						<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-marketActivityOwner">

							</select>
						</div>
						<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-marketActivityName">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-startTime" >
						</div>
						<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-endTime">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-cost" class="col-sm-2 control-label">成本</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-cost">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
<%--							textarea标签虽然是标签对但是获取值和设置值 使用val()方法 （html()方法也能用）--%>
							<textarea class="form-control" rows="3" id="edit-describe"></textarea>
						</div>
					</div>

				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>


<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
<%--						为了防止输入的数据不是按照格式要求 将日期输入框设置为只读--%>
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" <%--readonly--%>>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time " id="create-endTime" <%--readonly--%>>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
<%--				data-dismiss="modal" 表示关闭模态窗口
					为保存按钮添加时间 执行操作

--%>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>


	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endTime">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--
						这里data-toggle="modal" 表示触发事件 打开模态窗口
						data-target="#createActivityModal" 表示具体打开哪个模态窗口 根据#id
						由于这里占用了两个属性，如果要添加操作在事件上加不了 被写死了
						所以改为使用jQuery完成
					-->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkbox-all"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>