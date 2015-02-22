<%-- 
    Document   : questao6funcoes
    Created on : 19/02/2015, 00:12:54
    Author     : Valdir
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileUpload"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="includes/jstl.jsp" %>

<%-- capturando os campos do formulario cadastro de cliente e setando para o objeto Usuario --%>
<c:if test="${not empty param.nome}">
    <jsp:setProperty name="user" property="nome" value="${param.nome}" />
</c:if>
<c:if test="${not empty param.login}">
    <jsp:setProperty name="user" property="login" value="${param.login}" />
</c:if>
<c:if test="${not empty param.senha}">
    <jsp:setProperty name="user" property="senha" value="${param.senha}" />
</c:if>
<c:if test="${not empty param.validar}">
    <jsp:setProperty name="user" property="validar" value="${param.validar}" />
</c:if>

<%-- capturando os campos do formulario cadastro de produto e setando para o objeto Produto --%>
<c:if test="${not empty param.produtoId}">
    <jsp:setProperty name="produto" property="id" value="${param.produtoId}" />
</c:if>
<c:if test="${not empty param.produtoNome}">
    <jsp:setProperty name="produto" property="nome" value="${param.produtoNome}" />
</c:if>
<c:if test="${not empty param.produtoValor}">
    <jsp:setProperty name="produto" property="valor" value="${param.produtoValor}" />
</c:if>
<c:if test="${not empty param.produtoQuantidade}">
    <jsp:setProperty name="produto" property="quantidade" value="${param.produtoQuantidade}" />
</c:if>


<%-- validando cadastro de cliente --%>
<c:if test="${param.form=='cadastroCliente'}">
    <c:catch var="erroValidarCadCliente">
        <c:choose>
            <c:when test="${not empty param.nome and not empty param.login and not empty param.senha}">
                <c:catch var="erroCadCliente">
                    <c:redirect url="entrar.jsp">
                        <sql:query dataSource="${ds}" var="selectCliente" sql="select * from pessoas where login_pessoa=?">
                            <sql:param value="${user.login}" />
                        </sql:query>
                        <c:choose>
                            <c:when test="${selectCliente.rowCount==0}">
                                <sql:update dataSource="${ds}" sql="insert into pessoas values (null,?,?,?,?)">
                                    <sql:param value="${user.nome}" />
                                    <sql:param value="${user.login}" />
                                    <sql:param value="${user.senha}" />
                                    <sql:param value="c" />
                                    <c:param name="msg" value="cadastro realizado com sucesso!" />
                                </sql:update>
                            </c:when>
                            <c:otherwise>
                                <c:param name="msg" value="login ja cadastrado" />
                            </c:otherwise>
                        </c:choose>
                    </c:redirect>
                </c:catch>
                <c:if test="${erroCadCliente !=null}">
                    <c:redirect url="entrar.jsp">
                        <c:param name="msg" value="${erroCadCliente}" />
                    </c:redirect>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:redirect url="cadastro.jsp">
                    <c:param name="msg" value="preencha todos os campos corretamente!" />
                </c:redirect>
            </c:otherwise>
        </c:choose>
    </c:catch>
</c:if>
<c:if test="${erroValidarCadCliente != null}">
    <c:redirect url="cadastro.jsp">
        <c:param name="msg" value="Erro ao tentar cadastrar: ${erroValidarCadCliente}" />
    </c:redirect>
</c:if>

<%-- validando login --%>
<c:catch var="erroValidarLoginCliente">
    <c:if test="${param.form=='login'}">
        <c:choose>
            <c:when test="${not empty param.login and not empty param.senha}">
                <%-- cliente --%>
                <c:catch var="erroSelectCliente">
                    <sql:query dataSource="${ds}" var="selectCliente" sql="select * from pessoas where login_pessoa=? and senha_pessoa=? and tipo_pessoa='c';">
                        <sql:param value="${user.login}" />
                        <sql:param value="${user.senha}" />
                    </sql:query>
                </c:catch>
                <%-- administrador --%>
                <c:catch var="erroSelectAdministrador">
                    <sql:query dataSource="${ds}" var="selectAdmin" sql="select * from pessoas where login_pessoa=? and senha_pessoa=? and tipo_pessoa='a';">
                        <sql:param value="${user.login}" />
                        <sql:param value="${user.senha}" />
                    </sql:query>
                </c:catch>
                <c:choose>
                    <c:when test="${selectCliente.rowCount>0}">
                        <c:redirect url="home.jsp" >
                            <jsp:setProperty name="user" property="validar" value="1" />
                            <c:forEach var="nomeCliente" items="${selectCliente.rows}">
                                <jsp:setProperty name="user" property="id" value="${nomeCliente.id}" />
                                <jsp:setProperty name="user" property="nome" value="${nomeCliente.nome}" />
                            </c:forEach>
                        </c:redirect>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${selectAdmin.rowCount>0}">
                                <c:redirect url="administrador.jsp" >
                                    <jsp:setProperty name="user" property="validar" value="2" />
                                    <c:forEach var="nomeAdmin" items="${selectAdmin.rows}">
                                        <jsp:setProperty name="user" property="id" value="${nomeAdmin.id}" />
                                        <jsp:setProperty name="user" property="nome" value="${nomeAdmin.nome}" />
                                    </c:forEach>
                                </c:redirect>
                            </c:when>
                            <c:otherwise>
                                <c:redirect url="cadastro.jsp">
                                    <c:param name="msg" value="Cliente nao cadastrado, cadastre-se agora!" />
                                </c:redirect>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:redirect url="entrar.jsp">
                    <c:param name="msg" value="preencha todos os campos corretamente! ${user.login}" />
                </c:redirect>
            </c:otherwise>
        </c:choose>
        <c:if test="${erroSelectCliente != null}">
            <c:redirect url="entrar.jsp">
                <c:param name="msg" value="erro ao autenticar: ${erroSelectCliente}" />
            </c:redirect>
        </c:if>
        <c:if test="${erroSelectAdmin != null}">
            <c:redirect url="entrar.jsp">
                <c:param name="msg" value="erro ao autenticar: ${erroSelectAdmin}" />
            </c:redirect>
        </c:if>
    </c:if>
</c:catch>
<c:if test="${erroValidarLoginCliente != null}">
    <c:redirect url="cadastro.jsp">
        <c:param name="msg" value="Erro ao logar: ${erroValidarLoginCliente}" />
    </c:redirect>
</c:if>

<%-- validando cadastro de produto --%>
<c:if test="${param.form=='cadastroProduto'}">
    <c:catch var="erroValidarCadProduto">
        <c:choose>
            <c:when test="${not empty param.produtoNome and not empty param.produtoValor and not empty param.produtoQuantidade}">
                <c:catch var="erroCadProduto">
                    <sql:update dataSource="${ds}" var="insertProduto" sql="insert into produtos values (null,?,?,?);" >
                        <sql:param value="${produto.nome}" />
                        <sql:param value="${produto.valor}" />
                        <sql:param value="${produto.quantidade}" />
                    </sql:update>
                    <c:choose>
                        <c:when test="${insertProduto.rowCount>0}">
                            <c:redirect url="cadastroProduto.jsp">
                                <c:set var="msg" scope="session" value="Produto Cadastrado com sucesso!" />
                            </c:redirect>
                        </c:when>
                        <c:otherwise>
                            <c:redirect url="Produto.jsp">
                                <c:set var="msg" scope="session" value="Produto não cadastrado, tente novamente" />
                            </c:redirect>
                        </c:otherwise>
                    </c:choose>
                </c:catch>
            </c:when>
            <c:otherwise>
                <c:redirect url="produto.jsp">
                    <c:param name="msg" value="preencha todos os campos corretamente!" />
                </c:redirect>
            </c:otherwise>
        </c:choose>
    </c:catch>
</c:if>
<c:if test="${erroValidarCadCliente != null}">
    <c:redirect url="cadastro.jsp">
        <c:param name="msg" value="Erro ao tentar cadastrar: ${erroValidarCadCliente}" />
    </c:redirect>
</c:if>

<%-- editando produto --%>
<c:if test="${param.form=='editarProduto'}">
    <c:catch var="erroEditarProduto">
        <c:redirect url="produto.jsp">
            <sql:update dataSource="${ds}" var="updateProduto" sql="update produtos set nome_prod=?,valor_prod=?,quantidade_prod=? where id_prod=?" >
                <sql:param value="${produto.nome}" />
                <sql:param value="${produto.valor}" />
                <sql:param value="${produto.quantidade}" />
                <sql:param value="${produto.id}" />
            </sql:update>
            <c:param name="msg" value="alteracao feita com sucesso!" />
        </c:redirect>
    </c:catch>
</c:if>


<%-- apagando produto --%>
<c:if test="${param.form=='apagarProduto'}">
    <c:catch var="erroApagarProduto">
        <c:redirect url="produto.jsp">
            <sql:update dataSource="${ds}" var="deleteProduto" sql="delete from produtos where id_prod=?" >
                <sql:param value="${produto.id}" />
            </sql:update>
        </c:redirect>
    </c:catch>
</c:if>

<%-- editando usuario --%>
<c:if test="${param.form=='editarUsuario'}">
    <c:catch var="erroEditarUsuario">
        <c:redirect url="admincliente.jsp">
            <sql:update dataSource="${ds}" var="updateProduto" sql="update pessoas set nome_pessoa=?,login_pessoa=?,tipo_pessoa=? where id_pessoa=?" >
                <sql:param value="${param.usuarioNome}" />
                <sql:param value="${param.usuarioLogin}" />
                <sql:param value="${param.usuarioTipo}" />
                <sql:param value="${param.usuarioId}" />
            </sql:update>
            <c:param name="msg" value="alteracao feita com sucesso!" />
        </c:redirect>
    </c:catch>
</c:if>

<%-- apagando usuario --%>
<c:if test="${param.form=='apagarUsuario'}">
    <c:catch var="erroApagarUsuario">
        <c:redirect url="admincliente.jsp">
            <sql:update dataSource="${ds}" var="deleteUsuario" sql="delete from pessoas where id_pessoa=?" >
                <sql:param value="${param.usuarioId}" />
            </sql:update>
        </c:redirect>
    </c:catch>
</c:if>

<%-- cliente reservando produto --%>
<c:if test="${param.form =='reservarProduto'}">
    <c:catch var="erroReservaProduto">
        <c:redirect url="produto.jsp">
            <sql:update dataSource="${ds}" var="insertProdutoItens" sql="insert into itens values (?,?,?,?,?)">
                <sql:param value="${user.login}${util.data}" />
                <sql:param value="${produto.id}" />
                <sql:param value="${produto.quantidade}" />
                <sql:param value="${user.id}" />
                <sql:param value="<%= new java.util.Date() %>" />
            </sql:update>
            <%-- subtraindo do estoque de produtos --%>
            <sql:update dataSource="${ds}" var="updateProduto" sql="UPDATE produtos SET quantidade_prod = (quantidade_prod - ?) where id_prod = ?">
                <sql:param value="${produto.quantidade}" />
                <sql:param value="${produto.id}" />
            </sql:update>
            <c:param name="msg" value="${produto.nome} reservado!" />
        </c:redirect>
    </c:catch>
    <c:if test="${erroReservaProduto != null}">
        <c:redirect url="produto.jsp">
            <c:param name="msg" value="erro ao reservar: ${erroReservaProduto}" />
        </c:redirect>
    </c:if>
</c:if>

<%-- Fechar pedido --%>
<c:if test="${param.form = 'formFecharPedido'}" >
    <c:catch var="erroFecharPedido">
        <c:redirect url="pedido.jsp" >
            <sql:update dataSource="${ds}" var="insertPedido" sql="insert into pedidos values (?,?,?)">
                
            </sql:update>
        </c:redirect>
    </c:catch>
</c:if>