CREATE TABLE [dbo].[Tipo_cartao_credito] (
    [cd_cartao_credito] INT          NOT NULL,
    [nm_cartao_credito] VARCHAR (30) NOT NULL,
    [sg_cartao_credito] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    [cd_conta]          INT          NULL,
    [cd_conta_estorno]  INT          NULL,
    CONSTRAINT [PK_Tipo_cartao_credito] PRIMARY KEY CLUSTERED ([cd_cartao_credito] ASC) WITH (FILLFACTOR = 90)
);

