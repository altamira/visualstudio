CREATE TABLE [dbo].[Tipo_Forma_Materia_Prima] (
    [cd_tipo_forma_mat_prima]  INT          NOT NULL,
    [nm_tipo_forma_mat_prima]  VARCHAR (30) NULL,
    [sg_tipo_forma_mat_prima]  CHAR (10)    NULL,
    [qt_comprimento_mat_prima] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Forma_Materia_Prima] PRIMARY KEY CLUSTERED ([cd_tipo_forma_mat_prima] ASC) WITH (FILLFACTOR = 90)
);

