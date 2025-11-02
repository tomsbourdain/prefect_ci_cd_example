from prefect import flow, task

@task
def say_hello(name: str) -> str:
    print(f"Hello, {name}!")

@flow(name="hello_flow")
def hello_flow(name: str = "World"):
    say_hello(name)

if __name__ == "__main__":
    hello_flow.deploy("Prefect", name="hello_deployment")