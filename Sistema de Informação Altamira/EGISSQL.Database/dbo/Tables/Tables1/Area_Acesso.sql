CREATE TABLE [dbo].[Area_Acesso] (
    [cd_area_acesso]            INT          NOT NULL,
    [nm_area_acesso]            VARCHAR (40) NULL,
    [sg_area_acesso]            CHAR (10)    NULL,
    [ic_restrita_area_acesso]   CHAR (1)     NULL,
    [cd_departamento]           INT          NULL,
    [ic_identifica_area_acesso] CHAR (1)     NULL,
    [ds_area_acesso]            TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Area_Acesso] PRIMARY KEY CLUSTERED ([cd_area_acesso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Area_Acesso_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

