"use client";

import { Button, Modal } from "@heroui/react";

import { SourceRegisterForm } from "@/components/source-register-form";

export function SourceRegisterDialog() {
  return (
    <Modal>
      <Modal.Trigger>
        <Button variant="primary">Add Source</Button>
      </Modal.Trigger>
      <Modal.Backdrop>
        <Modal.Container placement="center" size="lg">
          <Modal.Dialog>
            <Modal.Header>
              <Modal.Heading>Add a Source</Modal.Heading>
            </Modal.Header>
            <Modal.Body>
              <SourceRegisterForm embedded />
            </Modal.Body>
            <Modal.Footer>
              <Modal.CloseTrigger>Close</Modal.CloseTrigger>
            </Modal.Footer>
          </Modal.Dialog>
        </Modal.Container>
      </Modal.Backdrop>
    </Modal>
  );
}
