<%-- 
    Document   : questao6funcoes
    Created on : 19/02/2015, 00:12:54
    Author     : Valdir
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="includes/jstl.jsp" %>

<%-- capturando os campos do formulario cadastro de cliente e setando para o objeto Usuario --%>
<jsp:setProperty name="user" property="nome" value="${param.nome}" />
<jsp:setProperty name="user" property="login" value="${param.login}" />
<jsp:setProperty name="user" property="senha" value="${param.senha}" />
<jsp:setProperty name="user" property="validar" value="${param.validar}" />


<%-- validando cadastro de cliente --%>
<c:if test="${param.form=='cadastroCliente'}">
    <c:catch var="erroValidarCadCliente">
        <c:choose>
            <c:when test="${not empty param.nome and not empty param.login and not empty param.senha}">
                <c:catch var="erroCadCliente">
                    <c:redirect url="index.jsp">
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

<%-- validando login cliente --%>
<c:catch var="erroValidarLoginCliente">
    <c:if test="${param.form=='loginCliente'}">
        <c:choose>
            <c:when test="${not empty param.login and not empty param.senha}">
                <c:catch var="erroSelectCliente">
                    <sql:query dataSource="${ds}" var="selectCliente" sql="select * from pessoas where login_pessoa=? and senha_pessoa=? and tipo_pessoa='c';">
                        <sql:param value="${user.login}" />
                        <sql:param value="${user.senha}" />
                    </sql:query>
                </c:catch>
                <c:choose>
                    <c:when test="${selectCliente.rowCount>0}">
                        <c:redirect url="pcliente.jsp" >
                            <jsp:setProperty name="user" property="validar" value="1" />
                        </c:redirect>
                    </c:when>
                    <c:otherwise>
                        <c:redirect url="cadastro.jsp">
                            <c:param name="msg" value="Cliente nao cadastrado, cadastre-se agora!" />
                        </c:redirect>
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
    </c:if>
</c:catch>
<c:if test="${erroValidarLoginCliente != null}">
    <c:redirect url="cadastro.jsp">
        <c:param name="msg" value="Erro ao logar: ${erroValidarLoginCliente}" />
    </c:redirect>
</c:if>