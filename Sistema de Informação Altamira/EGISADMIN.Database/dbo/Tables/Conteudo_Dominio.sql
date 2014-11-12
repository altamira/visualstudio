CREATE TABLE [dbo].[Conteudo_Dominio] (
    [cd_dominio]          INT          NOT NULL,
    [cd_faixa_dominio]    INT          NOT NULL,
    [nm_conteudo_dominio] VARCHAR (20) NOT NULL,
    [cd_conteudo_dominio] INT          NOT NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_atualiza]         DATETIME     NULL
);

