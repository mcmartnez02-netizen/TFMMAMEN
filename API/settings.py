from pathlib import Path

from pydantic import BaseModel, Field, SecretStr
from pydantic_settings import (
    BaseSettings,
    NestedSecretsSettingsSource,
    SettingsConfigDict,
)


class AppSettings(BaseModel):
    secretkey: SecretStr


class DbSettings(BaseModel):
    admin_password_hash: SecretStr = Field(validation_alias="adminPsswrd")    


class Settings(BaseSettings):
    app: AppSettings
    db: DbSettings

    model_config = SettingsConfigDict(
        env_prefix='MY_',
        env_nested_delimiter='__',
        secrets_dir=str(Path(__file__).parent / 'secrets'),
        secrets_nested_delimiter='_',
    )

    @classmethod
    def settings_customise_sources(
        cls,
        settings_cls,
        init_settings,
        env_settings,
        dotenv_settings,
        file_secret_settings,
    ):
        return (
            init_settings,
            env_settings,
            dotenv_settings,
            NestedSecretsSettingsSource(
                file_secret_settings,
                env_prefix='',  # secrets files are unprefixed: app_secretkey, db_passwd
            ),
        )

settings = Settings()