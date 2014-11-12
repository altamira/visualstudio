CREATE TABLE [dbo].[Requisicao_Interna_Baixa] (
    [cd_requisicao_interna]   INT          NOT NULL,
    [cd_item_req_interna]     INT          NOT NULL,
    [dt_baixa_requisicao]     DATETIME     NULL,
    [qt_baixa_requisicao]     FLOAT (53)   NULL,
    [cd_produto]              INT          NULL,
    [cd_funcionario]          INT          NULL,
    [nm_obs_baixa_requisicao] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_baixa_requisicao]     INT          NOT NULL,
    CONSTRAINT [PK_Requisicao_Interna_Baixa] PRIMARY KEY CLUSTERED ([cd_requisicao_interna] ASC, [cd_item_req_interna] ASC, [cd_baixa_requisicao] ASC)
);

