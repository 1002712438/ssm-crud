<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表(ajax请求)</title>
    <%--动态获取项目真实路径--%>
    <%-- <%pageContext.setAttribute("APP_PATH", request.getContextPath());%>--%>

    <%--引入jquery--%>
    <script src="static/js/jquery.js"></script>
    <%--引入bootstrap css样式--%>
    <link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css">
    <%--引入bootstrap js--%>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <%--base标签--%>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
</head>
<body>

<!--员工添加模态框-->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="inputEmpName" placeholder="员工姓名">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="inputEmail" placeholder="邮箱">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select name="dId" class="form-control" id="dept_add_select">
                                <%--部门提交部门id即可--%>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_add_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--员工修改模态框-->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="update_empName"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="input_update_Email"
                                   placeholder="邮箱">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select name="dId" class="form-control" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1 style="color: royalblue">SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-3 col-md-offset-9">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_modal_btn">删除</button>
        </div>
    </div>
    <%--显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emp_tb">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>empId</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area"></div>
        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>
<script type="text/javascript">
    //总记录数
    var totalRecord;
    var currentPage;
    var pageSize;
    //页面加载完成以后,直接发送一个ajax请求,要到分页数据
    $(function () {
        to_page(1);
    });

    //页面跳转
    function to_page(pn) {
        $.ajax({
            url: "emps3",
            type: "get",
            data: "pn=" + pn,
            success: function (response) {
                // console.log(response)
                // 1.解析并显示员工数据
                build_emp_table(response);
                // 2.解析并显示分页信息
                build_page_info(response);
                // 3.解析并显示分页条
                build_page_nav(response);
            }
        });
    }

    //解析并显示员工数据
    function build_emp_table(response) {
        //清空表格中的数据,防止append追加
        $("#emp_tb tbody").empty();
        var empList = response.data.pageInfo.list;
        $.each(empList, function (index, emp) {
            // alert(emp.empName)
            var checkboxTd = $("<td><input type='checkbox' class='check_item'/></td>")
            var empIdTd = $("<td></td>").append(emp.empId);
            var empNameTd = $("<td></td>").append(emp.empName);
            var genderTd = $("<td></td>").append(emp.gender == "M" ? "男" : "女");
            var emailTd = $("<td></td>").append(emp.email);
            var deptNameTd = $("<td></td>").append(emp.department.deptName);
            /*<button class="btn btn-info btn-sm">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                修改
                </button>*/
            var editBtn = $("<button></button>").addClass("btn btn-info btn-sm")
                .append("<span></span>").addClass("glyphicon glyphicon-pencil edit_btn").append("编辑");
            editBtn.attr("edit_id", emp.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append("<span></span>").addClass("glyphicon glyphicon-trash delete_btn").append("删除");
            delBtn.attr("dele_id", emp.empId);
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(checkboxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emp_tb tbody");
        });
    }

    //解析并显示分页信息
    function build_page_info(response) {
        //清空分页信息
        $("#page_info_area").empty();
        $("#page_info_area").append("当前第" + response.data.pageInfo.pageNum + "页,总共" + response.data.pageInfo.pages + "页,总" + response.data.pageInfo.total + "条记录")
        totalRecord = response.data.pageInfo.total;
        currentPage = response.data.pageInfo.pageNum;
        pageSize = response.data.pageInfo.pageSize;
    }

    //解析并显示分页条
    function build_page_nav(response) {
        //清空分页条
        $("#page_nav_area").empty();
        var nav = $("<nav></nav>");
        var ul = $("<ul></ul>").addClass("pagination");
        var firstLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var PreviousLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        //如果是第一页,就禁用首页和上一页
        if (response.data.pageInfo.hasPreviousPage == false) {
            firstLi.addClass("disabled");
            PreviousLi.addClass("disabled");
        } else {
            //给首页绑定单击事件
            firstLi.click(function () {
                to_page(1);
            })
            //给上一页绑定单击事件
            PreviousLi.click(function () {
                to_page(response.data.pageInfo.pageNum - 1);
            })
        }
        ul.append(firstLi).append(PreviousLi);
        $.each(response.data.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href", "#"));

            if (response.data.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }
            //给中间页绑定单击事件
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });
        var NextLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

        //如果是最后一页,就禁用下一页和末页
        if (response.data.pageInfo.hasNextPage == false) {
            NextLi.addClass("disabled");
            lastLi.addClass("disabled");
        } else {
            //给下一页绑定单击事件
            NextLi.click(function () {
                to_page(response.data.pageInfo.pageNum + 1);
            })
            //给末页绑定单击事件
            lastLi.click(function () {
                to_page(response.data.pageInfo.pages);
            })
        }
        ul.append(NextLi).append(lastLi);
        nav.append(ul).appendTo("#page_nav_area");
    }

    //点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //清除表单数据(表单完整重置(表单数据.表单样式))
        // $("#empAddModal form")[0].reset();
        reset_form("#empAddModal form");
        //查询数据库,得到部门信息
        getDepts("#dept_add_select");
        //弹出模态框
        $("#empAddModal").modal({
            backdrop: "static"
        });
    });

    //表单重置
    function reset_form(ele) {
        //清空表单数据
        $(ele)[0].reset();
        //清除表单样式
        $(ele).find("*").removeClass("has-success has-error");
        //清除显示文本数据
        $(ele).find(".help-block").text("");
    }

    //查询数据库,得到部门信息,显示在模态框中的下拉列表中
    function getDepts(ele) {
        $(ele).empty();
        $.ajax({
            url: "depts",
            type: "GET",
            success: function (response) {
                // console.log(response);
                $.each(response.data.depts, function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    //校验表单数据
    function validate_from_data() {
        //拿到要校验的数据,使用正则表达式
        //校验用户名
        var empName = $("#inputEmpName").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        // alert(regName.test(empName));
        if (!regName.test(empName)) {
            // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
            // $("#inputEmpName").parent().addClass("has-error");
            // $("#inputEmpName").next("span").text("用户名可以是2-5位中文或者6-16位英文和数字的组合");
            show_validate_msg("#inputEmpName", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
        } else {
            // $("#inputEmpName").parent().addClass("has-success");
            // $("#inputEmpName").next("span").text("");
            show_validate_msg("#inputEmpName", "success", "")
        }
        //校验邮箱
        var email = $("#inputEmail").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            // alert("邮箱格式不正确");
            // $("#inputEmail").parent().addClass("has-error");
            // $("#inputEmail").next("span").text("邮箱格式不正确");
            show_validate_msg("#inputEmail", "error", "邮箱格式不正确");
            return false;
        } else {
            // $("#inputEmail").parent().addClass("has-success");
            // $("#inputEmail").next("span").text("");
            show_validate_msg("#inputEmail", "success", "");
        }
        return true;
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele, status, msg) {
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //检验用户名是否可用
    $("#inputEmpName").change(function () {
        //发送ajax请求检验用户名是否可用
        $.ajax({
            url: "checkUser",
            type: "post",
            data: "empName=" + this.value,
            success: function (response) {
                if (response.code == 100) {
                    show_validate_msg("#inputEmpName", "success", "用户名可用");
                    $("#emp_add_btn").attr("ajax-va", "success");
                } else {
                    show_validate_msg("#inputEmpName", "error", response.data.va_msg);
                    $("#emp_add_btn").attr("ajax-va", "error");
                }
            }
        });
    });

    //员工保存
    $("#emp_add_btn").click(function () {
        // alert($("#empAddModal form").serialize())
        //1.模态框中提填写的表单数据提交到服务器进行保存
        //2.对填写的表单数据进行校验
        if (!validate_from_data()) {
            return false;
        }
        if ($("#emp_add_btn").attr("ajax-va") == "error") {
            return false;
        }
        //3.发送ajax请求保存员工
        $.ajax({
            url: "addEmp",
            type: "post",
            data: $("#empAddModal form").serialize(),
            success: function (response) {
                // console.log(response.message)
                //点击保存后
                if (response.code == 100) {
                    //1.关闭模态框
                    $("#empAddModal").modal("hide");
                    //2.来到最后一页,显示刚保存的数据
                    to_page(totalRecord);
                } else {
                    //请求处理失败
                    // console.log(response);
                    // 有哪个字段的错误信息就显示哪个字段
                    // alert(response.data.errorFiled.email);
                    // alert(response.data.errorFiled.empName);
                    if (undefined != response.data.errorFiled.email) {
                        show_validate_msg("#inputEmail", "error", response.data.errorFiled.email);
                    }
                    if (undefined != response.data.errorFiled.empName) {
                        show_validate_msg("#inputEmpName", "error", response.data.errorFiled.empName);
                    }
                }
            }
        });
    });

    //1.我们是在按钮创建之前就绑定了click,所以绑定不上
    //解决办法:1.可以在创建按钮的时候绑定 2.绑定.live()
    $(document).on("click", ".edit_btn", function () {
        // alert("edit");
        //1.查询部门信息
        getDepts("#dept_update_select");
        //2.查询员工信息
        getEmp($(this).attr("edit_id"));
        //将id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));
        //3.弹出模态框
        $("#empUpdateModal").modal({
            backdrop: "static"
        });
    });

    //查询员工信息
    function getEmp(id) {
        $.ajax({
            url: "getEmp/" + id,
            type: "GET",
            success: function (response) {
                // console.log(response)
                var empData = response.data.emp;
                $("#update_empName").text(empData.empName);
                $("#input_update_Email").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    //更新员工信息
    $("#emp_update_btn").click(function () {
        $.ajax({
            url: "updateEmp/" + $(this).attr("edit_id"),
            type: "PUT",
            data: $("#empUpdateModal form").serialize(),
            success: function (response) {
                // console.log(response)
                //关闭模态框
                $("#empUpdateModal").modal("hide");
                //回到本页面
                to_page(currentPage);
            }
        });
    });

    //删除员工信息(单个删除)
    $(document).on("click", ".delete_btn", function () {
        //弹出是否确认删除对话框
        // alert($(this).parents("tr").find("td:eq(1)").text());
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        if (confirm("确认删除[" + empName + "]吗?")) {
            //确认发送ajax请求删除即可
            $.ajax({
                url: "deleteEmp/" + $(this).attr("dele_id"),
                type: "DELETE",
                success: function (response) {
                    alert(response.message);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    //完成全选,全不选的功能
    $("#check_all").click(function () {
        //attr获取的checked是undefined;
        //dom原生的属性用prop获取,自定义的属性用attr获取
        // alert($(this).prop("checked"));
        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    //check_item
    $(document).on("click", ".check_item", function () {
        // alert($(".check_item:checked").length)
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag);

    });

    //批量删除
    $("#emp_del_modal_btn").click(function () {
        var empName = "";
        var del_ids = "";
        $.each($(".check_item:checked"), function () {
            // alert($(this).parents("tr").find("td:eq(2)").text());
            empName += $(this).parents("tr").find("td:eq(2)").text() + ",";
            del_ids += $(this).parents("tr").find("td:eq(1)").text() + "-";
        })
        //去除empName多余的,
        empName = empName.substring(0, empName.length - 1);
        //去除del_ids多余的-
        del_ids = del_ids.substring(0, del_ids.length - 1);
        if (confirm("确认删除[" + empName + "]员工吗?")) {
            //发送ajax请求删除
            $.ajax({
                url: "deleteEmp/" + del_ids,
                type: "DELETE",
                success: function (response) {
                    alert(response.message);
                    //回到本页面
                    to_page(currentPage);
                }
            });
        }
    });
</script>
</body>
</html>
