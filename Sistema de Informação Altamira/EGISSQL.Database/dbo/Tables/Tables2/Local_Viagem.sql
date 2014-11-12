CREATE TABLE [dbo].[Local_Viagem] (
    [cd_local_viagem]             INT          NOT NULL,
    [nm_local_viagem]             VARCHAR (60) NULL,
    [nm_complemento_local_viagem] VARCHAR (40) NULL,
    [ic_padrao_local_viagem]      CHAR (1)     NULL,
    [cd_pais]                     INT          NULL,
    [cd_estado]                   INT          NULL,
    [cd_cidade]                   INT          NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Local_Viagem] PRIMARY KEY CLUSTERED ([cd_local_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Local_Viagem_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);

