CREATE TABLE [dbo].[Seccao] (
    [cd_seccao]       INT          NOT NULL,
    [nm_seccao]       VARCHAR (40) NULL,
    [sg_seccao]       CHAR (10)    NULL,
    [cd_departamento] INT          NULL,
    [ic_ativa_seccao] CHAR (1)     NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Seccao] PRIMARY KEY CLUSTERED ([cd_seccao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Seccao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

