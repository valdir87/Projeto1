<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@include file="includes/jstl.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <c:if test="${user.validar!=1}">
            <c:redirect url="entrar.jsp">
                <c:param name="msg" value="Usuario invalido, tente novamente!" />
            </c:redirect>
        </c:if>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Controle de Pedidos</title>


        <style type="text/css"> @import url("estilos.css"); </style>

    </head>
    <body>
        <table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">

            <tr>
                <td colspan="3">
                    <%@ include file="includes/topo1.jsp" %>
                </td>
            </tr>

            <tr align="center">
                <td align="center" colspan="3" width="1000" >
                    <%@ include file="includes/menucli.jsp" %>
                </td>
            </tr>


            <tr align="center">
                <td align="justify" colspan="3" width="1000">
                    <fieldset>
                        <legend>Bem vindo <c:out value="${user.nome}" /></legend>
                        <br><br>
                        Nosso sistema foi desenvolvido com o objetivo de disponibilizar um ambiente de fácil gerenciamento.
                        <br><br>
                    </fieldset>
                </td>
            </tr>

        </table>
        <br><br>
        <div align="center">
            <c:if test="${param.msg != null}">
                <c:out value="${param.msg}" />
            </c:if>
        </div>
        <div id="listarProdutos" align="center">
            <sql:query dataSource="${ds}" var="selectProduto" sql="select * from produtos where quantidade_prod>0" />
            <table border="0" align="center">
                <c:forEach var="prod" items="${selectProduto.rows}" >
                    <form action="control.jsp" method="post" name="formProduto">
                        <tr>
                            <td width="150" align="left" nowrap="nowrap">
                                <c:out value="${prod.nome_prod}" /><br>
                            </td>
                            <td width="60" nowrap="nowrap">
                                R$ <c:out value="${prod.valor_prod}" /><br>  
                            </td>
                            <td nowrap="nowrap">
                                Quantidade: <select name="produtoQuantidade" size="1">
                                    <c:forEach var="i" begin="1" end="${prod.quantidade_prod}" >
                                        <option value="${i}"><c:out value="${i}"/></option>
                                    </c:forEach>
                                </select><br>
                            </td>
                            <td>
                                <input type="submit" value="reservar" />
                                <input type="hidden" name="form" value="reservarProduto" />
                                <input type="hidden" name="produtoId" value="${prod.id_prod}" />
                                <input type="hidden" name="produtoNome" value="${prod.nome_prod}" />
                            </td>
                        </tr>   
                    </form>
                </c:forEach>
            </table>
            <p></p>
            <div align="center">
                <form action="control.jsp" method="post">
                    <input type="hidden" name="form" value="formFecharPedido" />
                    <input type="submit" value="Fechar Pedido" />
                </form>
            </div>
            <p></p>
            <p></p>
        </div>