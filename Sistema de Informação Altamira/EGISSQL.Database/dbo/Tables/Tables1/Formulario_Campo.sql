CREATE TABLE [dbo].[Formulario_Campo] (
    [cd_campo_formulario] INT          NOT NULL,
    [nm_campo_formulario] VARCHAR (60) NULL,
    [ds_campo_formulario] TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Formulario_Campo] PRIMARY KEY CLUSTERED ([cd_campo_formulario] ASC) WITH (FILLFACTOR = 90)
);

