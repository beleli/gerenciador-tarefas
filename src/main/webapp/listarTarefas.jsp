<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    View de listagem (o "V" do MVC).
    Não acessa o banco: recebe a lista pronta em ${tarefas}, colocada pelo TarefaServlet.
    Se alguém abrir /listarTarefas.jsp direto, a lista não existe; então redireciona para /tarefas,
    que consulta o banco e volta para cá.
--%>
<c:if test="${tarefas == null}">
    <c:redirect url="/tarefas"/>
</c:if>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lista de Tarefas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4" style="max-width: 900px;">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Lista de Tarefas</h1>
        <a href="${pageContext.request.contextPath}/cadastroTarefas.jsp" class="btn btn-primary">Nova Tarefa</a>
    </div>

    <c:if test="${not empty param.sucesso}">
        <div class="alert alert-success">Tarefa cadastrada com sucesso! ID: ${fn:escapeXml(param.sucesso)}</div>
    </c:if>

    <c:if test="${not empty param.editado}">
        <div class="alert alert-success">Andamento atualizado com sucesso! ID: ${fn:escapeXml(param.editado)}</div>
    </c:if>

    <c:if test="${not empty param.excluido}">
        <div class="alert alert-success">Tarefa excluída com sucesso! ID: ${fn:escapeXml(param.excluido)}</div>
    </c:if>

    <c:if test="${not empty erro}">
        <div class="alert alert-danger">${fn:escapeXml(erro)}</div>
    </c:if>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Nome da Tarefa</th>
            <th>Data de Vencimento</th>
            <th>Prioridade</th>
            <th>Andamento</th>
            <th>Ações</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="tarefa" items="${tarefas}">
      
            <tr>
                <td>${tarefa.id}</td>
                <td>${fn:escapeXml(tarefa.nome)}</td>
                <td>${tarefa.dataVencimento}</td>
                <td>${tarefa.prioridade.rotulo}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/tarefas" method="post" class="d-flex gap-2 m-0">
                        <input type="hidden" name="acao" value="atualizar">
                        <input type="hidden" name="id" value="${tarefa.id}">
                        <select name="andamento" class="form-select form-select-sm">
                            <option value="pendente" ${tarefa.andamento.valor == 'pendente' ? 'selected' : ''}>Pendente</option>
                            <option value="em progresso" ${tarefa.andamento.valor == 'em progresso' ? 'selected' : ''}>Em Progresso</option>
                            <option value="pronto" ${tarefa.andamento.valor == 'pronto' ? 'selected' : ''}>Pronto</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-warning">Atualizar</button>
                    </form>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/tarefas" method="post" class="m-0">
                        <input type="hidden" name="acao" value="excluir">
                        <input type="hidden" name="id" value="${tarefa.id}">
                        <button type="submit" class="btn btn-sm btn-danger"
                                onclick="return confirm('Deseja realmente excluir esta tarefa?');">Deletar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty tarefas}">
            <tr>
                <td colspan="6" class="text-center text-muted">Nenhuma tarefa cadastrada.</td>
            </tr>
        </c:if>
        </tbody>
    </table>

</div>
</body>
</html>
