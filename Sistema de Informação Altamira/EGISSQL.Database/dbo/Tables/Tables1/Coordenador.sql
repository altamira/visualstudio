CREATE TABLE [dbo].[Coordenador] (
    [cd_coordenador]          INT           NOT NULL,
    [nm_coordenador]          VARCHAR (60)  NULL,
    [nm_fantasia_coordenador] VARCHAR (15)  NULL,
    [cd_telefone]             VARCHAR (15)  NULL,
    [cd_fax]                  VARCHAR (15)  NULL,
    [cd_email]                VARCHAR (150) NULL,
    [ds_coordenador]          TEXT          NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_interface]            INT           NULL,
    CONSTRAINT [PK_Coordenador] PRIMARY KEY CLUSTERED ([cd_coordenador] ASC)
);

