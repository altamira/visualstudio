CREATE TABLE [dbo].[Auditor] (
    [cd_auditor]      INT          NOT NULL,
    [nm_auditor]      VARCHAR (40) NULL,
    [cd_tipo_auditor] INT          NULL,
    [cd_departamento] INT          NULL,
    [cd_area]         INT          NULL,
    [nm_obs_auditor]  VARCHAR (40) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Auditor] PRIMARY KEY CLUSTERED ([cd_auditor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Auditor_Area] FOREIGN KEY ([cd_area]) REFERENCES [dbo].[Area] ([cd_area])
);

