CREATE TABLE [dbo].[Dominio] (
    [cd_dominio]          INT          NOT NULL,
    [nm_dominio]          VARCHAR (20) NOT NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_atualiza]         DATETIME     NULL,
    CONSTRAINT [PK_Dominio] PRIMARY KEY CLUSTERED ([cd_dominio] ASC) WITH (FILLFACTOR = 90)
);

