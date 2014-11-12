CREATE TABLE [dbo].[Tipo_Sepultamento] (
    [cd_tipo_sepultamento] INT          NOT NULL,
    [nm_tipo_sepultamento] VARCHAR (40) NULL,
    [sg_tipo_sepultamento] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Sepultamento] PRIMARY KEY CLUSTERED ([cd_tipo_sepultamento] ASC) WITH (FILLFACTOR = 90)
);

