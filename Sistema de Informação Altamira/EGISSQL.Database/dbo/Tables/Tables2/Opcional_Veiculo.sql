CREATE TABLE [dbo].[Opcional_Veiculo] (
    [cd_opcional]     INT          NOT NULL,
    [nm_opcional]     VARCHAR (40) NULL,
    [cd_ref_opcional] VARCHAR (20) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Opcional_Veiculo] PRIMARY KEY CLUSTERED ([cd_opcional] ASC) WITH (FILLFACTOR = 90)
);

