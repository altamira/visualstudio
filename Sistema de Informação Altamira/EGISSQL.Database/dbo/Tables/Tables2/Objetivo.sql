CREATE TABLE [dbo].[Objetivo] (
    [cd_objetivo]            INT          NOT NULL,
    [nm_objetivo]            VARCHAR (60) NULL,
    [ic_ativo_objetivo]      CHAR (1)     NULL,
    [cd_area]                INT          NULL,
    [cd_departamento]        INT          NULL,
    [dt_objetivo]            DATETIME     NULL,
    [dt_conclusao_objetivo]  DATETIME     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_usuario_responsavel] INT          NULL,
    [ds_objetivo]            TEXT         NULL,
    CONSTRAINT [PK_Objetivo] PRIMARY KEY CLUSTERED ([cd_objetivo] ASC) WITH (FILLFACTOR = 90)
);

