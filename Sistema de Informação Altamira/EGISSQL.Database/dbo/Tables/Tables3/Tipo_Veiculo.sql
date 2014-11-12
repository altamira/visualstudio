CREATE TABLE [dbo].[Tipo_Veiculo] (
    [cd_tipo_veiculo] INT          NOT NULL,
    [nm_tipo_veiculo] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_veiculo] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    [cd_departamento] INT          NOT NULL,
    CONSTRAINT [PK_Tipo_Veiculo] PRIMARY KEY CLUSTERED ([cd_tipo_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Veiculo_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

