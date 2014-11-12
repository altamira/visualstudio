CREATE TABLE [dbo].[View_Atributo] (
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [nm_mascara_view]           VARCHAR (20) NOT NULL,
    [nm_consulta_atributo_view] VARCHAR (40) NOT NULL,
    [nm_atributo_view]          VARCHAR (40) NOT NULL,
    [cd_natureza_atributo]      INT          NOT NULL,
    [cd_view]                   INT          NOT NULL,
    [cd_atributo_view]          INT          NOT NULL,
    CONSTRAINT [PK_View_Atributo] PRIMARY KEY CLUSTERED ([cd_view] ASC, [cd_atributo_view] ASC) WITH (FILLFACTOR = 90)
);

