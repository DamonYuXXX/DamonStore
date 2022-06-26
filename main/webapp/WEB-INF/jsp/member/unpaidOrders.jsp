<%--
  Created by IntelliJ IDEA.
  User: damonyu
  Date: 2019/8/25
  Time: 3:46 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<% pageContext.setAttribute("PATH", request.getContextPath());%>
<html>
<head>
    <title>Damon Store | My account</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--JQuery-->
    <script type="text/javascript" src="${PATH}/static/js/jquery-3.4.1.min.js"></script>
    <!-- Bootstrap -->
    <link href="${PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <link href="${PATH}/static/css/main.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css?family=Josefin+Sans:300,300i,400,400i,700,700i" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="${PATH}/static/css/font/flaticon.css" rel="stylesheet" type="text/css">

    <!-- Bootstrap Validator CSS -->
    <link href="${PATH}/static/css/bootstrapValidator.min.css" rel="stylesheet">
    <!-- Bootstrap Validator JavaScript -->
    <script type="text/javascript" src="${PATH}/static/js/bootstrapValidator.js"></script>

</head>
<body>
    <!-- Header -->
    <%@include file="header.jsp"%>
    <% if (member == null) {%>
    <jsp:forward page="login.jsp"></jsp:forward>
    <% } %>
    <div class="container-fluid">
        <div class="row">
            <div class="navbar-default sidebar col-lg-3" role="navigation">
                <div class="sidebar-nav container">
                    <ul class="nav nav-pills nav-stacked">
                        <li class="navbar-header"><h3>My account</h3></li>
                        <li><a href="${PATH}/member/myAccount"> Personal info</a></li>
                        <li><a href="${PATH}/member/address"> Address</a></li>
                        <li><a href="${PATH}/member/cart"> Shopping Cart</a> </li>
                        <li><a href="${PATH}/member/pointRecord"> Point record</a></li>
                        <li class="navbar-header"><h3>Orders</h3></li>
                        <li><a href="${PATH}/member/allOrders"> All orders</a></li>
                        <li class="active"><a href="${PATH}/member/unpaidOrders"> Unpaid orders</a></li>
                        <li><a href="${PATH}/member/unshippedOrders"> Unshipped orders</a></li>
                        <li><a href="${PATH}/member/unreceivedOrders"> Unreceived orders</a></li>
                    </ul>
                </div>
            </div>

            <div class="panel panel-default col-lg-9 container">
                <div class="panel-body">
                    <div style="width: 95%; height:100%; margin-bottom: 60px;" class="center-block">
                        <h1>Unpaid orders</h1>
                        <div id="orders">
                        </div>
                        <div class="modal fade" id="payModal" tabindex="-1" role="dialog" aria-labelledby="payModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="payModalLabel"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <form class="form-horizontal">
                                            <div class="form-group">
                                                <label class="col-sm-4 control-label">Price</label>
                                                <div class="col-sm-6">
                                                    <h4 id="price" class="form-control-static"></h4>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-4 control-label">Payment</label>
                                                <div class="col-sm-6">
                                                    <select id="payment" class="form-control">
                                                        <option value="weChat" selected>WeChat</option>
                                                        <option value="aliPay" selected>AliPay</option>
                                                        <option value="creditCard" selected>Credit card</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer" id="operation">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Footer -->
    <%@include file="footer.jsp"%>

    <script type="text/javascript">

        $.ajax({
            type: 'POST',
            url: '${PATH}/member/order/checkOrder',
            data: {"status":1},
            dataType: 'json',
            success:function (data) {
                let orderHtml = '';
                for (let i =0; i < data.length; i++) {
                    let status = 'Unpaid';
                    orderHtml += '<div style="margin-bottom:30px;padding-bottom:10px;border: 1px solid #d5d5d5;">\n' +
                        '            <div class="row" style="margin: 0px 0px;background-color: rgba(218,218,218,0.82);">\n' +
                        '                <h5 class="col-lg-3"><span class="text-muted">ID: </span><span>'+ data[i].order.id +'</span></h5>\n' +
                        '                <h5 class="col-lg-3">' + data[i].order.createTime + '</h5>\n' +
                        '                <h5 class="col-lg-2 col-lg-offset-4 text-danger">' + status + '</h5>\n' +
                        '            </div>\n' +
                        '            <div class="row" style="margin: 0px 0px;">\n' +
                        '                <h5 class="col-lg-3"><span class="text-muted">Ship to ' + data[i].order.receiverName + '</span></h5>\n' +
                        '                <h5 class="col-lg-2">' + data[i].order.receiverPhone + '</h5>\n' +
                        '                <h5 class="col-lg-7">' + data[i].order.receiverAddress + '</h5>\n' +
                        '            </div>\n' +
                        '            <ul id="itemsList" class="list-group">\n';
                    let items = data[i].orderItem;
                    console.log("items: " + items);
                    let itemHtml = '';
                    for (let j = 0; j < items.length; j++) {
                        let price = items[j].price;
                        let point = items[j].point;
                        let priceTag = '$' + price;
                        if (point != 0) {
                            priceTag += ' + ' + point + 'P';
                        }
                        let quantity = items[j].quantity;
                        itemHtml += '<li class="list-group-item">\n' +
                            '             <div class="row" style="margin-left: 10px;">\n' +
                            '                 <div class="col-lg-2 thumbnail">\n' +
                            '                     <img width="100px" height="100px" src="http://54.157.15.110:8080/images/product/' + items[j].url+'">\n' +
                            '                 </div>\n' +
                            '                 <div class="col-lg-5">\n' +
                            '                     <p>' + items[j].name + '</p>\n' +
                            '                 </div>\n' +
                            '                 <div class="col-lg-3">\n' +
                            '                     <h4 class="text-danger">' + priceTag + '</h4>\n' +
                            '                 </div>\n' +
                            '                 <div class="col-lg-2">\n' +
                            '                     <h4 class="text-muted quantityH">x ' + quantity + '</h4>\n' +
                            '                 </div>\n' +
                            '             </div>' +
                            '           </li>';
                    }
                    let totalPriceTag = '$'+data[i].order.totalPrice;
                    if (data[i].order.totalPoint != 0) {
                        totalPriceTag += ' + ' + data[i].order.totalPoint + 'P';
                    }
                    orderHtml += itemHtml;
                    orderHtml += '            </ul>\n' +
                        '            <div class="row">\n' +
                        '                <div class="col-lg-4 col-lg-offset-8">\n' +
                        '            <h4><span class="text-muted">Total: </span><span style="color: #d40f03">' + totalPriceTag + '</span></h4>\n' +
                        '                </div>\n' +
                        '            </div>\n' +
                        '            <div class="row">\n' +
                        '                <div class="col-lg-2 col-lg-offset-9">\n' +
                        '                   <button class="btn btn-danger" data-toggle="modal" data-target="#payModal" data-price=\"' +
                                            data[i].order.totalPrice + '\" data-id='+data[i].order.id+'>Pay</button>\n' +
                        '                </div>\n' +
                        '            </div>\n' +
                        '         </div>';
                }
                $('#orders').html(orderHtml);
            }
        });

        $('#payModal').on('show.bs.modal', function (event) {
            let button = $(event.relatedTarget);
            let orderID = button.data('id');
            let price = button.data('price');
            let modal = $(this);
            modal.find('.modal-title').text('Paying......');
            $('#price').html('$'+price);
            let goPayButton = '<button type="button" class="btn btn-primary" onclick="pay(' + orderID + ',' + price + ')">Pay</button>';
            $('#operation').html(goPayButton);
        });

        //付款
        function pay(orderID,price) {
            //获取支付方式
            let payment = $('#payment').val();
            $.ajax({
                type: 'POST',
                url: '${PATH}/member/order/pay',
                data: {"orderID":orderID,"price":price,"payment":payment},
                dataType: 'json',
                success:function (data) {
                    console.log("paied: " + data.result);
                    if (data.result == true) {
                        $.ajax({
                            type: 'POST',
                            url: '${PATH}/member/order/ship',
                            data: {"orderID":orderID},
                            dataType: 'json',
                            success:function (data) {
                                console.log("shipped: " + data.result);
                            }
                        });
                    }
                    window.location.href = "${PATH}/member/allOrders";
                }
            });
        }
    </script>
</body>
</html>
