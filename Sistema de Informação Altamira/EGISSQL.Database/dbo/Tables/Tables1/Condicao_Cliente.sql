CREATE TABLE [dbo].[Condicao_Cliente] (
    [cd_condicao_cliente] INT          NOT NULL,
    [nm_condicao_cliente] VARCHAR (30) NOT NULL,
    [sg_condicao_cliente] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Condicao_Cliente] PRIMARY KEY CLUSTERED ([cd_condicao_cliente] ASC) WITH (FILLFACTOR = 90)
);

