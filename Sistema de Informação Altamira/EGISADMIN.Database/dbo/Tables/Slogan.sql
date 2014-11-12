CREATE TABLE [dbo].[Slogan] (
    [cd_slogan]           INT          NOT NULL,
    [nm_slogan]           VARCHAR (30) NOT NULL,
    [ds_slogan]           TEXT         NULL,
    [ic_ativo_slogan]     CHAR (1)     NOT NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [CD_USUARIO_ATUALIZA] INT          NULL,
    [DT_ATUALIZA]         DATETIME     NULL,
    CONSTRAINT [PK_Slogan] PRIMARY KEY CLUSTERED ([cd_slogan] ASC) WITH (FILLFACTOR = 90)
);

